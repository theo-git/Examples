Service DPL2
=========

Sets up a full DPL2 Docker container environment on Container VMs deployed by Terraform.

Requirements
------------

None

Role Variables
--------------

TBD

Dependencies
------------

- { role: service_sshfs, when: root_access == "yes" and dp2_location == "seattle" }
- { role: service_docker, when: root_access == "yes" }
- { role: service_stackdriver, when: dp2_location != "seattle" }
- { role: service_prometheus_exporters_common, when: root_access == "yes" and dp2_location == "seattle" }
- { role: service_prometheus_node_exporter, when: root_access == "yes" and dp2_location == "seattle" }

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

Author Information
------------------

Theo
