####################Variablen######################

variable "region" {
  type = string
  default = "europe-west4"
}

variable "zone" {
  type = string
  default = "europe-west4-a"
}

variable "machine_type" {
  type = string
  #Ubuntu 22.04
  default = "e2-micro"
}

variable "image" {
  type = string
  #Ubuntu 22.04
  default = "ubuntu-os-cloud/ubuntu-2204-lts"
}

variable "disk_size" {
  type = number
  default = 40
}

variable "instance_user" {
  type = string
  default = "alexei_chmelev"
}

variable "private_key" {
  type = string
  default = "Transformers.pem"
}

variable "install_script" {
  type = string
  default = "nothing.sh"
}

variable "gpu_count" {
  type = number
  default = 0
}

variable "gpu_type" {
  type = string
  default = "dummy"
}


provider "google" {
  project     = "transformers-409614"
  region      = var.region
  zone        = var.zone
}
resource "google_compute_instance" "transformers" {
  provider = google
  name = "transformers"
  machine_type = var.machine_type

  metadata = {
    ssh-keys = "${var.instance_user}:${file("Transformers.pub")}"
  }

  network_interface {
    network = "default"
    access_config {}
  }

  boot_disk {
    initialize_params {
      image = var.image
      size = var.disk_size
    }
  }

  scheduling {
    on_host_maintenance = "TERMINATE"
  }



  guest_accelerator {
     type = var.gpu_type
     count = var.gpu_count
  }
  
  provisioner "local-exec" {
    command = "sleep 60"
  }

  provisioner "local-exec" {
    command = "scp -o StrictHostKeyChecking=no -i ${var.private_key} ${var.install_script} ${var.instance_user}@${self.network_interface.0.access_config.0.nat_ip}:${var.install_script}"
  }
  provisioner "local-exec" {
    command = "ssh -o StrictHostKeyChecking=no -i ${var.private_key} ${var.instance_user}@${self.network_interface.0.access_config.0.nat_ip} \"chmod 755 ${var.install_script}\""
  }

  provisioner "local-exec" {
    command = "ssh -o StrictHostKeyChecking=no -i ${var.private_key} ${var.instance_user}@${self.network_interface.0.access_config.0.nat_ip} ./${var.install_script}"
  }
  
}

output "PublicIP" {
    value = google_compute_instance.transformers.network_interface.0.access_config.0.nat_ip
    description = "The public IP address of the newly created instance"
}