# Ansible role: service_docker

This Ansible Role installs and configures [Docker](https://www.docker.com) on Ubuntu <= 18.04 & Redhat-based Linux Distributions.

It can also setup a systemd unit for a Docker container to execute pre-launch commands on the start/stop/restart of a container and to autostart the container if the host is restarted. 

## Requirements

None.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

    docker_edition: 'ce'
    docker_package: "docker-{{ docker_edition }}"
    docker_package_state: present

The `docker_edition` should be either `ce` (Community Edition) or `ee` (Enterprise Edition). You can also specify a specific version of Docker to install using the distribution-specific format: Red Hat/CentOS: `docker-{{ docker_edition }}-<VERSION>`; Debian/Ubuntu: `docker-{{ docker_edition }}=<VERSION>`.

You can control whether the package is installed, uninstalled, or at the latest version by setting `docker_package_state` to `present`, `absent`, or `latest`, respectively. Note that the Docker daemon will be automatically restarted if the Docker package is updated. This is a side effect of flushing all handlers (running any of the handlers that have been notified by this and any other role up to this point in the play).

    docker_service_state: started
    docker_service_enabled: true
    docker_restart_handler_state: restarted

Variables to control the state of the `docker` service, and whether it should start on boot. If you're installing Docker inside a Docker container without systemd or sysvinit, you should set these to `stopped` and set the enabled variable to `no`.

    docker_install_compose: true
    docker_compose_version: "1.22.0"
    docker_compose_path: /usr/local/bin/docker-compose

(Optional) Docker Compose installation.

    docker_apt_release_channel: stable
    docker_apt_arch: amd64
    docker_apt_repository: "deb [arch={{ docker_apt_arch }}] https://download.docker.com/linux/{{ ansible_distribution|lower }} {{ ansible_distribution_release }} {{ docker_apt_release_channel }}"
    docker_apt_ignore_key_error: True

(Used only for Debian/Ubuntu.) You can switch the channel to `edge` if you want to use the Edge release.

    docker_yum_repo_url: https://download.docker.com/linux/centos/docker-{{ docker_edition }}.repo
    docker_yum_repo_enable_edge: 0
    docker_yum_repo_enable_test: 0

(Used only for RedHat/CentOS.) You can enable the Edge or Test repo by setting the respective vars to `1`.

    docker_users:
      - user1
      - user2

A list of system users to be added to the `docker` group (so they can use Docker on the server).

#### (Optional) Docker Login variables:
Omit the variables if you do not wish to login to a Docker registry.

* docker_registry - The URL of the Docker registry you wish to login to in order to pull an image. 
* `docker_login_method` - Can be set to `gcloud` or `json_key`.
    * `gcloud` - Uses an access-token to login to the GCR according to the documentation [here](https://cloud.google.com/container-registry/docs/advanced-authentication#access_token).
    * `Json_key` - Uses a service account JSON key file to login to the GCR according to the documentation [here](https://cloud.google.com/container-registry/docs/advanced-authentication#json_key_file)
    * Or set the variable to "" if you wish to skip authenticating with the GCR.
* docker_login_json_key: "/path/to/gcr_json_key" #Set only if using json_key method above.

#### (Optional) Docker container Systemd service variables:
The variables below are used to create a Systemd service unit for the Docker container.  Omit the variables if you do not wish to create a Systemd unit for the container.

* `docker_container_image` (**required**) - the URL to the Docker image the service uses. Example: "us.gcr.io/example-project/example/example:{{ dpl2_version }}"
* `docker_container_args` - (optional) arbitrary list of arguments to the `docker run` command
* `docker_container_cmd` - (optional) command to the container run command (the part after the image name)
* `docker_container_env` - (optional) key/value pairs of ENV vars that need to be present
* `docker_container_env_file` - (optional) full path and filename of file that stores the ENV vars. (default: "{{ sysconf_dir }}/{{ docker_container_name }}"
* `docker_container_prelaunch` - (optional) command or script that you wish to execute before starting the container.
* `docker_container_start` - command you wish to execute to start the Docker container. 
* `docker_container_stop` - command you wish to execute to stop the Docker container. 
* `docker_container_volumes` (optional, default: _[]_) - List of `-v` arguments
* `docker_container_ports` (optional, default: _[]_) - List of `-p` arguments
* `docker_container_link` (optional, default: _[]_) - List of `--link` arguments
* `docker_container_labels` (optional, default: _[]_) - List of `-l` arguments
* `docker_container_docker_pull` (default: _yes_) - whether the docker image should be pulled
* `docker_container_service_enabled` (default: _yes_) - whether the service should be enabled
* `docker_container_service_masked` (default: _no_) - whether the service should be masked
* `docker_container_service_state` (default: "_started_") - state the service should be in - set to "absent" to remove the Docker container service.

## Dependencies

None.

## Example Playbook

```yml
- hosts: all
  roles:
    - service_docker
```

## Author Information

Theo created this role to meet internal requirements based off of the 2 roles below:
- [Ansible-Galaxy Docker-install role](https://github.com/geerlingguy/ansible-role-docker)
- [Ansible-Galaxy Docker-systemd role](https://github.com/mhutter/ansible-docker-systemd-service)
