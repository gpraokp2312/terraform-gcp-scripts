# versions.tf
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = "thermal-shuttle-116107"
  region  = "asia-south1"
}

# Service account for the instances
resource "google_service_account" "web" {
  account_id   = "sa-web-server"
  display_name = "Web Server Service Account"
}

# Instance template defines the VM configuration
resource "google_compute_instance_template" "web" {
  name_prefix  = "gps-instance-template"
  machine_type = "e2-micro"
  region       = "asia-south1"

  disk {
    source_image = "ubuntu-os-cloud/ubuntu-2204-lts"
    auto_delete  = true
    boot         = true
    disk_size_gb = 20
    disk_type    = "pd-ssd"
  }

  network_interface {
    network    = "default"
   

    # No external IP - traffic comes through the load balancer
    # access_config {} # Uncomment to add an external IP
  }

  # Metadata startup script
  metadata = {
    startup-script = <<-EOF
      #!/bin/bash
      apt-get update
      apt-get install -y nginx
      echo "Hello from $(hostname)" > /var/www/html/index.html
      systemctl start nginx
    EOF
  }

  # Service account and scopes
  service_account {
    email  = google_service_account.web.email
    scopes = ["cloud-platform"]
  }

  # Network tags for firewall rules
  tags = ["web", "http-server"]

  labels = {
    environment = "production"
    role        = "web-server"
  }

}
