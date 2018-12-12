import argparse
from google.cloud import pubsub_v1

PROJECT = "{{ gmail_watch_gcp_project }}"
TOPIC_NAME = "projects/example-project/topics/gmail_watch_{{ source_email_address_username.stdout }}"

def main():
    set_topic_policy(PROJECT, TOPIC_NAME)

def set_topic_policy(PROJECT, TOPIC_NAME):
    """Sets the IAM policy for a topic."""
    client = pubsub_v1.PublisherClient()
    topic_path = client.topic_path(PROJECT, TOPIC_NAME)

    policy = client.get_iam_policy(topic_path)

    # Grant the Gmail Push API Publisher permission to the topic.
    policy.bindings.add(
        role='roles/pubsub.publisher',
        members=['gmail-api-push@system.gserviceaccount.com'])

    # Apply the policy
    policy = client.set_iam_policy(topic_path, policy)

    print('IAM policy for topic {} set: {}'.format(TOPIC_NAME, policy))

if __name__ == '__main__':
    parser = argparse.ArgumentParser(
        description=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter
    )
    parser.add_argument('PROJECT', help='Your Google Cloud project ID')

    subparsers = parser.add_subparsers(dest='command')

    set_topic_policy_parser = subparsers.add_parser(
        'set-topic-policy', help=set_topic_policy.__doc__)
    set_topic_policy_parser.add_argument('TOPIC_NAME')
