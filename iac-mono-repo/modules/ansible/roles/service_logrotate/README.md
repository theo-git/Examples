# service_logrotate

This role ensures logrotate is installed and enables the quick setup of additional logrotate scripts.

## Requirements

None

## Role Variables

**logrotate_scripts**: A list of logrotate scripts and the directives to use for the rotation.

* name - The name of the script that will be stored in /etc/logrotate.d/.
* path - The path to the log to rotate.
* paths - A list of paths to logs to rotate.
* options - A list of options for logrotate. See the logrotate documentation for details.
* scripts - A dictionary of scripts for logrotate. See Example below for details.

```
logrotate_scripts:
  - name: barrel
    path: "/var/log/example/example_server.log"
    options:
      - daily
      - notifempty
      - compress
      - delaycompress
      - maxage 2
      - maxsize 209715200
      - create
      - copytruncate

```

```
logrotate_scripts:
  - name: example
    paths:
        - "/var/log/example.log"
        - "/var/log/example.1.log"
    options:
      - daily
      - notifempty
      - compress
      - delaycompress
      - maxage 2
      - maxsize 209715200
      - create
      - copytruncate
```

## Dependencies

None

## Example Playbook

Setting up logrotate for additional nginx logs with a postrotate script.

```
- hosts: all
  vars:
    logrotate_scripts:
      - name: nginx-options
        path: /var/log/nginx/options.log
        options:
          - daily
          - notifempty
          - compress
          - delaycompress
          - maxage 2
          - maxsize 209715200
          - create
          - copytruncate

      - name: nginx-test-scripts
        path: /var/log/nginx/test.log
        options:
          - daily
          - size 25M
        scripts:
          postrotate: "echo testing"

  roles:
    - service_logrotate
```
