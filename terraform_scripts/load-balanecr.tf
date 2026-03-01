# Backend service using the managed instance group
resource "google_compute_backend_service" "web" {
  name                  = "gps-backend-web"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 30
  health_checks         = [google_compute_health_check.web.id]
  load_balancing_scheme = "EXTERNAL_MANAGED"

  depends_on = [
    google_compute_region_instance_group_manager.web,
    google_compute_region_autoscaler.web  
]  

backend {
    group           = google_compute_region_instance_group_manager.web.instance_group
    balancing_mode  = "UTILIZATION"
    max_utilization = 0.8
    capacity_scaler = 1.0
  }

  # Connection draining - wait for existing requests to complete
  connection_draining_timeout_sec = 300

  # Logging
  log_config {
    enable      = true
    sample_rate = 1.0
  }
}
