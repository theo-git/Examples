#!/bin/bash

DOMAINS=(
ops-bot-test.multiscalehn.com
ops-bot.multiscalehn.com
stage.providence.multiscalehn.com
uat.providence.multiscalehn.com
providence.multiscalehn.com
jnj.api.multiscalehn.com
analytics.multiscalehn.com
stage.jnj.api.multiscalehn.com
piwik.multiscalehn.com
sentry.multiscalehn.com
doku.multiscalehn.com
paradigm.multiscalehn.com
grafana.multiscalehn.com
gitlab.multiscalehn.com
ops-api.multiscalehn.com
conan.multiscalehn.com
wiki.multiscalehn.com
dev.providence.multiscalehn.com
demo-dashboards.multiscalehn.com
jenkins.multiscalehn.com
dev.analytics.multiscalehn.com
docker.multiscalehn.com
dev.multiscalehn.com
hive.uat.multiscalehn.com
hive.prod.multiscalehn.com
hive-stage.multiscalehn.com
hive.dev.multiscalehn.com
chf.multiscalehn.com
matomo.multiscalehn.com
matomointernal.multiscalehn.com #Separate domain required for Hive/EDQ apps to bypass the Matomo-IAP on the domain above.
)

WILDCARDCERTDOMAINS=(
dev.multiscalehn.com
)

#The domains on the whitelist below exist to ensure that the script doesn't delete the domain certs from the ops-bot VM.
#The SECUREREMOVEWHITELIST certs must remain on the ops-bot VM to ensure ops-bot gitwebhook functionality and other special use cases.
SECUREREMOVEWHITELIST=(
jenkins.multiscalehn.com
dev.analytics.multiscalehn.com
demo-dashboards.multiscalehn.com
ops-bot-test.multiscalehn.com
ops-bot.multiscalehn.com
dev.providence.multiscalehn.com
dev.multiscalehn.com
hive.uat.multiscalehn.com
hive.prod.multiscalehn.com
hive-stage.multiscalehn.com
hive.dev.multiscalehn.com
chf.multiscalehn.com
matomo.multiscalehn.com
matomointernal.multiscalehn.com #Separate domain required for Hive/EDQ apps to bypass the Matomo-IAP on the domain above.
)

#DEPRECATED DOMAINS:
#dev.mdsrest.multiscalehn.com #The VM & project for this domain was turned off since it was decided that it was no longer in use.
#jira.multiscalehn.com #The VM was turned off and Jira is no longer in use right now.
#www.multiscalehn.com # This cert is managed by Squarespace.
