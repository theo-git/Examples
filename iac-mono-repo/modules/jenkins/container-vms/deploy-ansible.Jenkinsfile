library 'core-library'

def runnerSettings = [
    gcloudJenkinsCredentialId:"EXAMPLE-CICD-ANSIBLE-RUNNER",
    gcloudProject:"example-customer-project",
    ansibleInventory:"modules/ansible/inventories/",
    ansibleTargetTagChoices:["ansible-container-vm", "ansible-container-vm-1", "ansible-container-vm-2"],
    ansiblePlaybook:"modules/ansible/service_container_vm.yml",
    ansibleJenkinsCredentialId:"EXAMPLE-CICD-ANSIBLE-RUNNER-SSH"
]

RunAnsible(runnerSettings)
