#!/usr/bin/env python3
#Script to fetch all Google Cloud DNS A records, check when their SSL certs expire, and print them out in a nice format.
import subprocess 

#Ignore a domain by adding it to the list below:
IgnoreList=[]
gcloudCmd="""gcloud dns record-sets list --zone EXAMPLE-ZONE --project=EXAMPLE-PROJECT --filter='TYPE!~SOA|TXT|SPF|CNAME|MX|NS' | awk '{if ($1 !="NAME") print $1}' | sed 's/.$//'"""
domains=subprocess.check_output(gcloudCmd,shell=True).decode("utf-8").splitlines()
print(','.join(map(str,domains)))

#Check the expiration date on each domain
for domain in domains:
 if domain not in IgnoreList:
  renewalCmd="echo | openssl s_client -servername {} -connect {}:443 2>/dev/null | openssl x509 -enddate -noout | cut -d= -f 2"
  renewal=subprocess.check_output(renewalCmd.format(domain, domain),shell=True).decode("utf-8")
  print("Domain: {}\nExpires: {}".format(domain, renewal))
