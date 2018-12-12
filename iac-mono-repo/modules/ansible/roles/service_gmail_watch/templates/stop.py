from __future__ import print_function
import googleapiclient.discovery
from oauth2client.service_account import ServiceAccountCredentials
import httplib2
import types
import json
import GmailServiceObject
from GmailServiceObject import SOURCE_EMAIL_ADDRESS, TOPIC 

# All SYSTEM labels are included in the list below. This is needed to ensure no stray system labels are still being watched.
SYSTEM_LABELS = ['CATEGORY_UPDATES', 'UNREAD', 'DRAFT', 'CATEGORY_PROMOTIONS', 'INBOX', 'CATEGORY_SOCIAL',
                 'CATEGORY_PERSONAL', 'CATEGORY_FORUMS', 'TRASH', 'CHAT', 'IMPORTANT', 'SENT', 'STARRED', 'SPAM']

def main():
    service = GmailServiceObject.AuthorizeService()
    # Google Pub/Sub topic below that listens for requests from this script.
    # When a request is received, the topic then POSTs to the push-endpoint-doamin so that it can fire an email to PagerDuty so that DevOps can be alerted.
    request = {
        'labelIds': SYSTEM_LABELS,
        'topicName': TOPIC
    }

    # 'Me' simply uses the current authenticated user in delegated_credentials above.
    result = service.users().stop(
        userId='me',
    ).execute()

    if type(result) is types.StringType:
        print("WATCH DEACTIVATED: The watch that was monitoring {} was turned off!\nIMPORTANT: Please make sure to remove the corresponding cronjob for {} that will reinitialize the watch every 24 hours if it's not removed.".format(SOURCE_EMAIL_ADDRESS, SOURCE_EMAIL_ADDRESS))
        print(json.dumps(result))
        return result
    # If the watch fails to stop, then the string below will be logged to syslog, which will trigger a Stackdriver Alert to devops@example-company.com.
    else:
        print("CRITICAL: The watch method for {} FAILED to STOP as requested! Please investigate!\n".format(SOURCE_EMAIL_ADDRESS))
        print(json.dumps(result))
        return result

if __name__ == '__main__':
    main()
