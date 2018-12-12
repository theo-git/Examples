#!/bin/bash

function verify_certs {
    for domain in "${DOMAINS[@]}"; do
        expirationDate=$(echo | openssl s_client -connect "$domain":443 2>/dev/null | openssl x509 -noout -enddate | cut -d = -f 2 | xargs -0 date +"%Y%m%d" -d)
        #IMPORTANT: $remainingDays doesn't include the current day and the expiration day due to Certbot restrictions.
        export remainingDays=$(( ($(date '+%s' -d "$expirationDate") - $(date '+%s')) / 86400 ))

        echo RUNNING CERT EXPIRATION CHECK:
        echo domain: "$domain"
        echo expiration date: "$expirationDate"
        echo days remaining until expiration: "$remainingDays"
        echo "(^^Not including today's date and the expiration day)"

        if [ "$remainingDays" -lt 30 ]
        then
            gather_vars
            backup_certs
            verify_dirs
            cd /opt/certbot/InfrastructureState || exit #Exit in case 'cd' fails

            #STEP 1:
            echo CREATING THE RENEWED CERT ON THE CERBOT HOST FOR "$domain" AFTER CONFIRMING ALL THE DEPENDENCIES ARE MET:
            echo ""

            if [[ "${WILDCARDCERTDOMAINS[@]}" =~ $domain ]]
            then
                echo ""
                echo "IMPORTANT: $domain" IS ON THE WILDCARDCERTDOMAINS LIST SO A WILDCARD CERT WILL BE CREATED FOR "$domain":
                echo ""
                ansible-playbook -i service_certbot_1.yml -v --vault-password-file=~/.ssh/certbot_ansible_vault_password --extra-vars "certbot_domain_to_renew=$domain certbot_wildcardcert_domain=*.$domain  certbot_email=$CERTBOT_EMAIL"
            else
                echo ""
                echo "IMPORTANT: $domain" is NOT on the WILDCARDCERTDOMAINS list so a wildcard cert will NOT be created for "$domain":
                echo ""
                ansible-playbook -i service_certbot_1.yml -v --vault-password-file=~/.ssh/certbot_ansible_vault_password --extra-vars "certbot_domain_to_renew=$domain certbot_wildcardcert_domain=NOTaWILDCARDCERTDOMAIN  certbot_email=$CERTBOT_EMAIL"
            fi

            #STEP 2:
            echo SECURE-COPYING THE RENEWED CERT TO THE TARGET HOST AND/OR LOADBALANCER:
            echo ""
            ansible-playbook -i inventories/certbot/"$domain" service_certbot_2.yml -v --vault-password-file=~/.ssh/certbot_ansible_vault_password --extra-vars "certbot_domain_to_renew=$domain ansible_ssh_private_key_file=~/.ssh/google_compute_engine"

            echo ""
            echo WAITING 1 MINUTE FOR THE NEW CERT TO TAKE EFFECT
            echo ""
            sleep 60

            echo ""
            echo CHECKING TO ENSURE THAT THE CERT WAS RENEWED...
            echo ""
            unset remainingDays
            unset expirationDate
            expirationDate=$(echo | openssl s_client -connect "$domain":443 2>/dev/null | openssl x509 -noout -enddate | cut -d = -f 2 | xargs -0 date +"%Y%m%d" -d)
            export remainingDays=$(( ($(date '+%s' -d "$expirationDate") - $(date '+%s')) / 86400 ))
            echo ""
            echo CERT CHECK RESULTS:
            echo domain: "$domain"
            echo expiration date: "$expirationDate"
            echo days remaining until expiration: "$remainingDays"
            echo "(^^Not including today's date and the expiration day)"
            echo ""

            if [ "$remainingDays" -lt 30 ]
            then
                echo ""
                echo CRITICAL: THE CERT FAILED TO RENEW. PLEASE INVESTIGATE!
                echo ""
                if [ "$remainingDays" -lt 10 ]
                then
                    echo ""
                    echo EMERGENCY: THE SSL CERT FOR THE DOMAIN ABOVE IS LESS THAN 10 DAYS FROM EXPIRING. PLEASE RENEW ASAP TO AVOID AN OUTAGE!
                    echo ""

                fi
            else
                echo ""
                echo SUCCESS! THE CERT WAS RENEWED SUCCESSFULLY!
                echo ""
            fi

            #STEP 3:
            if [[ "${SECUREREMOVEWHITELIST[@]}" =~ $domain ]]
            then
                echo THE DOMAIN "$domain" IS ON THE SECURE_REMOVE_WHITELIST SO THE CERT FOR IT WILL NOT BE SECURELY DELETED FROM THE CERBOT HOST.
            fi
            if [[ ! "${SECUREREMOVEWHITELIST[@]}" =~ $domain ]]
            then
                echo BACKING UP CERT FILES TO GCS BEFORE SECURELY-DELETEING THE "$domain" CERT FROM THE CERBOT.
                backup_certs
                echo SECURELY-DELETEING THE "$domain" CERT FROM THE CERBOT NOW THAT IT WAS SECURELY COPIED TO THE TARGET HOST.
                echo NOTE: "$domain" WAS NOT ON THE SECURE_REMOVE_WHITELIST SO FOR SECURITY THE CERT MUST BE SECURELY DELETED FROM THE CERBOT HOST.
                echo ""
                ansible-playbook -i inventories/certbot/"$domain" service_certbot_3.yml -v --vault-password-file=~/.ssh/certbot_ansible_vault_password --extra-vars "certbot_domain_to_renew=$domain"
            fi
        else
            echo THE CERTIFICATE DOES NOT NEED TO BE RENEWED.
            echo We will renew the cert when there are less than 30 days until expiration as required by Letsencrypt Certbot.
            echo ""
        fi
    done
}
