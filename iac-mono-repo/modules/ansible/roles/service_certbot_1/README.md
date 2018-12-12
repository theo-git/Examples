Certbot Letsencrypt SSL Certicate Creation & Renewal Automation For VMs, Loadbalancers, and Kubernetes
=========

While the [Official EFF Certbot Tool](https://certbot.eff.org) has an `auto-renew` SSL certificate feature, some companies cannot utilize the feature because it requires modifications to company firewall rules to allow Letsencrypt's servers to connect to company web server roots to run a certificate renewal, which poses a security risk. Therefore, the automation below was created to renew certificates using Certbot's manual DNS-TXT record challenge plugin, which allows for the added security of not needing to allow a non-BAA 3rd-party access to company production, stage, or dev web servers.  Ansible is utilized to automate connecting to each target host to install new/renewed certificates & perform tasks to ensure the certificate is utilized as expected.

The Ansible playbooks `service_certbot_*.yml` all setup up the necessary configuration to automate the renewal of a SSL certificate for a Google Cloud DNS domain name.  This automation supports both non-wildcard and wildcard domains.

Requirements
------------

- Google Cloud Platform
- Gcloud SDK setup & authenticated with a user has the Project Editor IAM role in the target Project. 
- [IAC-REPO](https://gitlab.example.com/devops/iac) pull access.
- Setup the Ansible Vault password file in the LastPass shared folder titled `Shared-MSHN Services` and share `Ansible Vault password for Certbot Cert renewal automation`. Currently only folks in DevOps have access to this folder.
- [Ansible 2.4.0.0 or greater installed](http://docs.ansible.com/ansible/latest/intro_installation.html)
  - Using pip: `pip install ansible`
  - _pip is the best practice way of installing Ansible_

To add a new domain for renewal
--------------

1. Clone the IAC-REPO to your local machine.
2. While in the repo directory, open the script:
  - `modules/ansible/roles/service_certbot_1/files/domains.sh` 
3. Add the new domain to the `DOMAINS` list in the script.
  - `IMPORTANT:` For domains that need a `WILDCARD CERT`:
     - Add the base domain to the `DOMAINS` list. 
         - Example: `*.dev.example.com` would be added to `DOMAINS` list as `dev.example.com`.
     - Add the base domain also to the `WILDCARDCERTDOMAINS` list below.
         - Example: `*.dev.example.com` would be added to `WILDCARDCERTDOMAINS` list as `dev.example.com`.
4. `CRITICAL`: As a temporary measure, add the new domain to the `SECUREREMOVEWHITELIST` in the script.  
     - This ensures that the cert is not deleted from the ops-bot VM while you work to get your domain-specific renewal script running as expected, which you'll create below.
         - From our experience, you'll likely need to test & change your domain-specific script a few times before your target web server accepts the new/renewed cert.
     - [Due to Letsencrypt's rate limits](https://letsencrypt.org/docs/rate-limits/), only 5 duplicate certificates for the same domain per week are allowed.  This includes renewals.
     - If you don't whitelist your domain, then the automation will remove the cert from the ops-bot everytime you run the script.  
          - After 5 runs, Letsencrypt will refuse to create another duplicate cert and will make you wait 1 week before it will create or renew a existing cert for the same domain.
     - Once your domain-specific renewal script is working as expected, you'll then need to go back into the master script and remove your domain from the whitelist.
          - This is for security to ensure only 1 copy of the cert is available on the target host.
5. Create a new file called `YOUR-SUBDOMAIN.example.com` with the contents below in the directory `inventories/certbot`.
  - Example file:
    ```
    modules/ansible/inventories/certbot/test.example.com
    ```
  - Contents:
    ```
    [certbot_target_host]
    TARGET-IP
    ```
6. Create a new Bash script titled `YOUR-SUBDOMAIN.example.com.sh` that contains the command(s) needed to restart the webserver, docker container, and/or gcloud commands to update the load-balancer the target host is behind.
  - Example file:
    ```
    modules/ansible/roles/service_certbot_2/files/test.example.com.sh
    ```
  - Example Contents:
    ```
    #!/bin/bash
    service nginx restart
    ```
7. Then push your changes to Git. 
  - Once they're merged into `master`, a Git webhook will trigger a `git pull` on the `Cerbot Host's local copy of CERTBOT-REPO` to incorporate your changes.
  - After updating the repo, then the certbot master script will be run manually to create or renew a cert for your newly added domain.

8. `IMPORTANT`: Once everything is working as expected, you'll then need to go back into the master script and remove your domain from the `SECUREREMOVEWHITELIST`.
  - This is for security to ensure only 1 copy of the cert is available on the target host.

Dependencies
------------

- None

Author Information
------------------

Automation and documentation written by Theo.
