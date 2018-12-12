### Infrastructure as Code (IAC) Mono-Repository Layout

```
├── envs
│   └── example-customer
│       ├── dev
│       │   ├── container-vms-project
│       │   └── k8s-project
│       ├── prod
│       │   ├── container-vms-project
│       │   └── k8s-project
│       └── stage
│       │   ├── container-vms-project
│       │   └── k8s-project
│   ├── internal
│       ├── dev
│       │   ├── corp-project
│       ├── prod
│       │   ├── corp-project
│       └── stage
│       │   ├── corp-project
└── modules
    ├── ansible
    ├── kubernetes
    └── terraform
        └── gcp
            ├── apps
            ├── base
            └── services
```

- `envs`: Contains all projects, divided by Customer > Deployment Environment > Project. 
    - In the project folder, we expect to see a `config.tf` file. This file acts as the file that glues all necessary configurations together.

- `modules`: Contains all pieces of built projects and should be built out to be reusable.
    - `modules > `ansible` contains any playbooks or roles specifically related to any projects or services. The same is true for Modules > Bash and Modules > Kubernetes.
    - `modules > `terraform` should be split by `platform > apps / base / services`.
    - `platform > services` should be considered lowest level. Here we build out pieces of an application using services like `kubernetes` or `vm`. The service should be made out of three configuration files; `input.tf`, `output.tf`, and `{service_name}.tf`.
    - `platform > apps` should glue together the necessary services to have a running application. As we see with services, this should be composed of an `input.tf`, `output.tf`, and `{application_name}.tf`.
    - `platform > base` contains all components necessary for a fresh project, including but not limited to firewall rules, routing rules, IAM permissions, etc.
