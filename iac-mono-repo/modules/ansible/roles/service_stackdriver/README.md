Service Stackdriver
=========

Installs Stackdriver Logging & Monitoring Agents.
Configures custom log streaming to Google Cloud.
Rotates custom log.

Requirements
------------

Google Cloud Platform

Role Variables
--------------

The variables below need to be defined if you wish to stream a log file other than syslog to Google Cloud Stackdriver Logging API.
```
stackdriver_log_name: "example_service"
stackdriver_log_format: "json" #Other formats options found here: https://cloud.google.com/logging/docs/agent/configuration#configure
stackdriver_log_path: "/var/log/{{ stackdriver_log_name }}.log"
stackdriver_log_tag: "example_service"
stackdriver_logrotate_options: |
    {
        rotate 7
        hourly
        notifempty
        delaycompress
        compress
    }
```
If they are undefined, the role will simply install the Stackdriver Logging Agent, which will only stream /var/log/syslog to Google Cloud by default.

Dependencies
------------

None

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

Author Information
------------------

Theo
