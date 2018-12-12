#!/bin/bash

#This script performs the actions most K8s domains require to use a new/renewed Cerbot SSL cert.
#It cannot be run alone. Instead it should be run by a domain specific script, like "dev.example.com.sh".

export CERTDIR="/etc/letsencrypt/live/$DOMAIN"
export FULLCHAIN_PATH="$CERTDIR/fullchain.pem"
export PRIVKEY_PATH="$CERTDIR/privkey.pem"
export BACKUPDIR="/opt/certbot/finalize/backups/$DOMAIN-secrets"

##Ensure the backup directory exists.
mkdir -p $BACKUPDIR

#Ensure gcloud and kubectl are installed.
export CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)"
grep -q -F "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" /etc/apt/sources.list.d/google-cloud-sdk.list || echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" >> /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
apt-get update && apt-get install google-cloud-sdk
apt-get install kubectl

#Get creds and set config for the cluster.
gcloud container clusters get-credentials $CLUSTER --zone $ZONE --project $PROJECT
gcloud config set container/cluster $CLUSTER --project $PROJECT 

#Backup the existing cert secret just in case.
kubectl get secret $CERTSECRETNAME --namespace=$NAMESPACE -o yaml > $BACKUPDIR/$CERTSECRETNAME-"$(date +%Y-%m-%d)"
##Encrypt the backup for security.
ansible-vault encrypt $BACKUPDIR/$CERTSECRETNAME-"$(date +%Y-%m-%d)" --vault-password-file=~/.ssh/certbot_automation_ansible_vault_password
##Delete the existing cert secret.
kubectl delete secret $CERTSECRETNAME --namespace=$NAMESPACE
#Create the new cert secret.
kubectl create secret tls $CERTSECRETNAME --cert=$FULLCHAIN_PATH --key=$PRIVKEY_PATH --namespace=$NAMESPACE

#Delete the target pods so that the cluster can automatically recreate them, which will ensure that the target pods use the new cert secret.
##NOTE: This usually does not incur any downtime as kubernetes automatically creates the new pods as the old ones are deleted and hands off any running jobs to the new pods seamlessly.
while IFS= read -r podname; do
    TARGET_POD_NAMES+=( "$podname" )
done < <( kubectl get pods --namespace=$NAMESPACE | awk '{print $1}' | grep "$PODNAME" )

function delete_target_pods {
    for podname in "${TARGET_POD_NAMES[@]}"; do
        echo "Below are the pods we will delete:"
        echo "$podname"
        
        kubectl delete pod "$podname" --namespace=$NAMESPACE
    done
}

delete_target_pods

#Wait 10 seconds for the target pods to be recreated.
echo "WAITING 10 SECONDS FOR THE TARGET POD TO RECREATE"
sleep 10
#Use the command below to check the pod status. Grep will give an exit code of 0 if it finds an target podname with the healthy pod status of 'Running'. Else it will return a 1.
#The 'Running' status is necessary since the pod can be stuck in an 'Error' or other states we would need to act upon if the pod remains in those problematic states.
kubectl get pods --namespace=$NAMESPACE | awk '{print $1" "$3}' | grep "$POD_CHECK_STRING"
export GREPEXITSTATUS=$?
#The count starts at 10 because of the 'sleep 10' above.
count=10
done=0

while [ $GREPEXITSTATUS -eq 1 -a $done -eq 0 ]
do
    echo "THE NEW TARGET POD IS STILL NOT IN A HEALTHY 'RUNNING' STATE."
    echo "WAITING ANOTHER 10 SECONDS FOR THE POD TO RETURN TO A HEALTHY STATE."
    sleep 10 
    count=$((count+10))
    echo "Elasped waiting time is: $count"
    echo "CHECKING FOR A HEALTHY TARGET POD STATUS AGAIN:"
    kubectl get pods --namespace=$NAMESPACE | awk '{print $1" "$3}' | grep "$POD_CHECK_STRING"
    if [ $count == 120 ]
    then
        echo "CRITICAL: THE TARGET POD IS NOT RUNNING SUCCESSFULLY AFTER WAITING 2 MINUTES, WHICH IS UNUSUAL.  PLEASE INVESTIGATE!"
        echo "A BACKUP OF THE PREVIOUS CERT IS BEING APPLIED IN AN ATTEMPT TO RESTORE SERVICE."
        echo "TROUBLESHOOTING INFO:|"
        echo "DOMAIN=$DOMAIN"
        echo "BACKUPDIR=$BACKUPDIR"
        echo "PROJECT=$PROJECT"
        echo "CLUSTER=$CLUSTER"
        echo "ZONE=$ZONE"
        echo "NAMESPACE=$NAMESPACE"
        echo "CERTSECRETNAME=$CERTSECRETNAME"
        #Rollback the SSL cert to the previous working backup:
        kubectl delete secret $CERTSECRETNAME --namespace=$NAMESPACE
        #Decrypt the previous backup so it can be restored:
        ansible-vault decrypt $BACKUPDIR/$CERTSECRETNAME-"$(date +%Y-%m-%d)" --vault-password-file=~/.ssh/certbot_automation_ansible_vault_password
        kubectl create -f $BACKUPDIR/$CERTSECRETNAME-"$(date +%Y-%m-%d)"
        delete_target_pods
        #Re-encrypt the backup for security:
        ansible-vault encrypt $BACKUPDIR/$CERTSECRETNAME-"$(date +%Y-%m-%d)" --vault-password-file=~/.ssh/certbot_automation_ansible_vault_password
        #Ensure the restored target pods come back up.
        sleep 10
        kubectl get pods --namespace=$NAMESPACE | awk '{print $1" "$3}' | grep "$POD_CHECK_STRING"
        RESTOREEXITSTATUS=$?
        count=10
        doneNested=0
        while [ $RESTOREEXITSTATUS -eq 1 -a $doneNested -eq 0 ]
        do
            echo "WE RESTORED THE PREVIOUS WORKING SSL CERT FROM A BACKUP AND DELETED THE TARGET POD TO GET IT TO USE THE RESTORED CERT."
            echo "BUT THE TARGET POD IS STILL NOT IN A HEALTHY 'RUNNING' STATE."
            echo "WAITING ANOTHER 10 SECONDS FOR THE POD TO RETURN TO A HEALTHY STATE."
            sleep 10
            count=$((count+10))
            echo "Elasped waiting time is: $count"
            echo "CHECKING FOR A HEALTHY TARGET POD STATUS AGAIN:"
            kubectl get pods --namespace=$NAMESPACE | awk '{print $1" "$3}' | grep "$POD_CHECK_STRING"
            if [ $count == 120 ]
            then
                echo "WARNING: WE TRIED TO RESTORE THE PREVIOUS WORKING BACKUP OF THE SSL-CERT SECRET BUT THE TARGET POD IS STILL NOT IN A HEALTHY 'RUNNING' STATE AFTER 2 MINUTES.  PLEASE INVESTIGATE!"
                echo "TROUBLESHOOTING INFO:"
                echo "DOMAIN=$DOMAIN"
                echo "BACKUPDIR=$BACKUPDIR"
                echo "PROJECT=$PROJECT"
                echo "CLUSTER=$CLUSTER"
                echo "ZONE=$ZONE"
                echo "NAMESPACE=$NAMESPACE"
                echo "CERTSECRETNAME=$CERTSECRETNAME"
                doneNested=1
            fi
        done
        done=1
    fi
done
