variable "project" {
  description = "Google Cloud Project"
  type        = string
}

variable "source_image" {
  description = "Source image"
  type        = string
}

variable "instance_type" {
  description = "Instance Type"
  type        = string
  default     = "e2-medium"
}

variable "zone" {
  description = "Google Compute zone"
  type        = string
  default     = "us-east1-b"
}

variable "preemptible" {
  description = "Google Compute zone"
  type        = bool
  default     = false
}

variable "ssh_public_key" {
  description = "File path to ssh public key"
  default     = "~/.ssh/id_rsa.pub"
}

resource "google_compute_instance" "linux" {
  project      = var.project
  name         = terraform.workspace
  machine_type = var.instance_type
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.source_image
    }
  }

  network_interface {
    network = "default"
    access_config {
      // dynamic public ip
    }
  }

  metadata = {
    used_by   = "github-actions"
    workspace = terraform.workspace
    ssh-keys  = "ci:${file(var.ssh_public_key)}"
  }

  scheduling {
    preemptible       = var.preemptible
    automatic_restart = var.preemptible == true ? false : true
  }

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/monitoring"
    ]
  }
}