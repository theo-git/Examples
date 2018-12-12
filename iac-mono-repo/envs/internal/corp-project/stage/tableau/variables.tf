// GCP Project Variables
variable "project_name" {
  description = "Chosen project name for the project. Will affect naming of buckets, networks and the like."
  default     = "mshn-prod-providence"
}

variable "region" {
  description = "Region for the project"
  default     = "us-central1"
}

variable "cidr" {
  description = "Default CIDR to be used for the project"
  default     = ""
}

variable "cidr_gw" {
  description = "Default CIDR GW"
  default     = ""
}

variable "credentials" {
  description = "Credentials file for the account provisioning"
  default     = "/Users/theopulver/.credentials/mshn-prod-providence-9caf76a93ddd.json"
}

variable "billing_account" {
  default = ""
}

variable "org_id" {
  default = ""
}

// Tableau GCP Compute instance variables

variable "instance_name" {
  default = "tableau-server-dev"
}

variable "tableau_domain_name" {
  default = "dev.analytics.multiscalehn.com"
}

variable "tags" {
  default = [
    "tableau-server",
  ]
}

#Tableau requires a minimum of 2 cores and 8GB of RAM.  Therefore 'n1-standard-4' is recommended as a minimum base for Dev servers.
#For Production servers, 'n1-standard-8' is recommended.
variable "machine_type" {
  default = "n1-standard-4"
}

variable "instance_zone" {
  default = "us-central1-c"
}

variable "boot_disk_image" {
  default = "ubuntu-os-cloud/ubuntu-1604-lts"
}

variable "boot_disk_size" {
  default = "80"
}

# subnetwork - The name of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided.
variable "subnetwork_name" {
  default = "services-us-central1"
}

#(Optional) Internal IP: Leave the variable below to auto-assign an internal IP to the VM.  Else specific a static internal IP. 
variable "internal_ip_address" {
  default = ""
}

#(Optional) External IP: Leave the variable below to auto-assign an external IP to the VM.  Else specific a static external IP. 
variable "external_ip_address" {
  default = ""
}

# Service account block
# email - (Optional) The service account e-mail address. If not given, the default Google Compute Engine service account is used.
variable "service_account_email" {
  default = ""
}

# (Optional) 
#variable "network_name" {
# default = ""
#}


# name - (Optional) The name of the instance template. If you leave this blank, Terraform will auto-generate a unique name.
#(Optional) The project in which the resource belongs. If it is not provided, the provider project is used.
#variable "project" {
# default = 
#}
# tags - (Optional) Tags to attach to the instance.
# description - (Optional) A brief description of this resource.
#variable "instance_description" {
# default = "" 
#}
# Scheduling block
# preemptible - (Optional) Allows instance to be preempted. This defaults to false.
#variable "preemptible" {
#  default = "false"
#}
# New boot disk block
# source_image - (Required if source not set) The image from which to initialize this disk. This can be one of: the image's self_link, projects/{project}/global/images/{image}, projects/{project}/global/images/family/{family}, global/images/{image}, global/images/family/{family}, family/{family}, {project}/{family}, {project}/{image}, {family}, or {image}.
#variable "source_image" {
#  default = "" 
#}
# auto_delete - (Optional) Whether or not the disk should be auto-deleted. This defaults to true.
#variable "auto_delete" {
# default = "" 
#}
# Metadata block
#variable "metadata_key" {
# default = ""
#}
#variable "metadata_pair" {
# default = ""
#}
#The lines below are usually not needed.  Leave them commented out unless the values are set in variables.tf
#variable "can_ip_forward" {
# default = ""
#}
# For existing boot disk block
#variable "existing_disk_name" {
# default = ""
#}

