'''
Gmail Inbox Watch Script:

This script is run after an alert message is sent to the destination.
It is also run daily using a cronjob as recommended by the Gmail API documentation below to ensure that the watch() on the target inbox doesn't expire:
    https://developers.google.com/gmail/api/guides/push
'''

from __future__ import print_function
import googleapiclient.discovery
from oauth2client.service_account import ServiceAccountCredentials
import httplib2
import types
import json
from google.cloud import pubsub_v1
import GmailServiceObject
from GmailServiceObject import SOURCE_EMAIL_ADDRESS, DESTINATION_EMAIL_ADDRESS, TOPIC, PROJECT

# All SYSTEM labels except ["UNREAD", "CATEGORY_PERSONAL", "INBOX"] are included in the list below. This is needed to ensure only new unread messages are watched for and alerted upon.
EXCLUDED_LABELS = ['CATEGORY_UPDATES', 'DRAFT', 'CATEGORY_PROMOTIONS', 'CATEGORY_SOCIAL',
                   'CATEGORY_FORUMS', 'TRASH', 'CHAT', 'IMPORTANT', 'SENT', 'STARRED', 'SPAM']

def main():
    service = GmailServiceObject.AuthorizeService()
    '''
    The variable below configures the watch method to monitor the WATCH_INBOX for messages that don't include the labels in the EXCLUDED_LABELS list.
    This causes only new messages with the labels ["UNREAD", "CATEGORY_PERSONAL", "INBOX"] to trigger a notification to the Google Pub/Sub topic used in the variable below.
    When the topic receives a notification from the watch, the topic then POSTs to {{ push_endpoint_domain }} that then caused an email to be sent to the specified destination.
    '''
    exclude_labels = {
        'labelIds': EXCLUDED_LABELS,
        'labelFilterAction': 'exclude',
        'topicName': TOPIC
    }

    # The service object below ensures that the watch method only notifies on new messages that have the labels ["UNREAD", "CATEGORY_PERSONAL", "INBOX"].
    # 'Me' simply uses the current authenticated user in delegated_credentials above.
    result = service.users().watch(
        userId='me',
        body=exclude_labels
    ).execute()

    # Ensure the watch method sets up successfully:
    if type(result) is types.DictType:
        print("SUCCESS: The watch method for {} that monitors for new messages in that email inbox was initialized successfully!\nWe will reinitialize the watch every 24 hours, if it isn't re-run before then, as recommended by Google to ensure it does not expire.".format(SOURCE_EMAIL_ADDRESS))
        print(json.dumps(result))
        historyID = result.get("historyId")
        historyIDfile = open("historyID", 'w')
        historyIDfile.write(historyID)
        return result
    # If the watch fails to initialize, then the string below will be logged to syslog, which will trigger a Stackdriver Alert to devops@example-company.com.
    else:
        print("CRITICAL: The watch method for {} FAILED to initialize! Please investigate!\nWe will try to reinitialize the watch every 24 hours, if it isn't re-run before then, as recommended by Google to ensure it does not expire.".format(WATCH_INBOX))
        print(json.dumps(result))
        return result

if __name__ == '__main__':
    main()
