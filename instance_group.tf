# Regional managed instance group (spans multiple zones)
data "google_compute_instance_template" "existing_template" {
  name = "gps-instance-template20260301102024034300000001"
}

resource "google_compute_region_instance_group_manager" "web" {
  name               = "gps-mig-mumbai"
  base_instance_name = "gps-vm-instance"
  region             = "asia-south1"

  # Reference the instance template
  version {
instance_template=data.google_compute_instance_template.existing_template.self_link
  }

  # Target size - number of instances (overridden by autoscaler if present)
  target_size = 1

  # Distribute instances across these zones
  distribution_policy_zones = [
    "asia-south1-a",
    "asia-south1-b",
    "asia-south1-c",
  ]

  # Even distribution across zones
  distribution_policy_target_shape = "EVEN"

  # Named port for load balancer health checks
  named_port {
    name = "http"
    port = 80
  }

  named_port {
    name = "https"
    port = 443
  }

  # Auto-healing policy
  auto_healing_policies {
    health_check      = google_compute_health_check.web.id
    initial_delay_sec = 300  # Give instances 5 minutes to start before checking health
  }

  # Update policy for rolling updates
  update_policy {
    type                           = "PROACTIVE"
    minimal_action                 = "REPLACE"
    most_disruptive_allowed_action = "REPLACE"
    max_surge_fixed                = 3
    max_unavailable_fixed          = 0
    replacement_method             = "SUBSTITUTE"
  }
}
