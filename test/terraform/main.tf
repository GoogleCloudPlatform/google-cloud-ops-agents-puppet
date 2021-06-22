variable "project" {
  default = "united-aura-313415"
}

variable "preemptible" {
  default = true
}

// ci will create this key, but it can be changed to something
// else if desired. Installing an ssh key allows tools like
// inspec to interact with the vm without dealing with
// gcloud ssh. Changing this key is not useful unless running
// from a workstation with a different key
variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "os" {}

variable "image" {
  description = "Images built from test/packer"
  type = map
  default = {
    "ubuntu-2004" = "puppet-ubuntu-2004-lts"
    "ubuntu-1804" = "puppet-ubuntu-1804-lts"
    "ubuntu-1604" = "puppet-ubuntu-1604-lts"
    "debian-10"   = "puppet-debian-10"
    "debian-9"    = "puppet-debian-9"
    "centos-s8"   = "puppet-centos-stream-8"
    "centos-8"    = "puppet-centos-8"
    "centos-7"    = "puppet-centos-7"
    "rhel-8"      = "puppet-rhel-8"
    "rhel-7"      = "puppet-rhel-7"
    "suse-15"     = "puppet-sles-15"
    "suse-12"     = "puppet-sles-12"
  }
}

module "linux" {
  source         = "./instance/linux"
  project        = var.project
  source_image   = var.image[var.os]
  preemptible    = var.preemptible
  ssh_public_key = "~/.ssh/id_rsa.pub"
}