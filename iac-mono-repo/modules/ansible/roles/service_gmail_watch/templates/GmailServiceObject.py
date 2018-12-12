import googleapiclient.discovery
from oauth2client.service_account import ServiceAccountCredentials

'''
CRITICAL: 
The source email address below CANNOT be an email alias or a group email address.  
It must be the actual address of an individual GSuite user.  
Otherwise the Gmail API with return a 500 Backend Error.
'''
# Below is the email address of the account you want this script to send FROM.
SOURCE_EMAIL_ADDRESS = "{{ gmail_watch_source_email_address }}"
'''
Below is the email address of the party you wish to send TO:
To prevent a push notification loop, the email address should NOT be the same as the address above.
'''
DESTINATION_EMAIL_ADDRESS = "{{ gmail_watch_destination_email_address }}"
SCOPES = ['https://mail.google.com/',
          'https://www.googleapis.com/auth/admin.directory.user.security',
          'https://www.googleapis.com/auth/pubsub']
SERVICE_ACCOUNT_FILE = 'gmail-dwd-credentials-example.json'
PROJECT = "{{ gmail_watch_gcp_project }}"
TOPIC = "projects/example-project/topics/gmail_watch_{{ source_email_address_username.stdout }}"

def AuthorizeService():
    # Setup the credentials:
    credentials = ServiceAccountCredentials.from_json_keyfile_name(
        SERVICE_ACCOUNT_FILE, scopes=SCOPES)
    # The line below is needed for Domain Wide Delegration (DWD), which allows the service account to impersonate the gmail user.
    # This is needed so the SA can monitor the inbox of any customer-facing email inbox and then alert DevOps if a new message arrives.
    delegated_credentials = credentials.create_delegated(
        SOURCE_EMAIL_ADDRESS)
    service = googleapiclient.discovery.build(
        'gmail', 'v1', credentials=delegated_credentials)
    return service
