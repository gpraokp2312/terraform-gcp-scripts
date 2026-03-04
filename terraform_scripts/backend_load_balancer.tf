# Backend service using the managed instance group
resource "google_compute_region_backend_service" "web" {
  name                  = "gps-backend-web"
  protocol              = "HTTP"
  port_name             = "http"
  timeout_sec           = 30
  health_checks         = [google_compute_region_health_check.web.id]
  region 		= "asia-south1"
  load_balancing_scheme = "EXTERNAL"

  depends_on = [
    google_compute_region_instance_group_manager.web,
    google_compute_region_autoscaler.web  
]  

backend {
    group           = google_compute_region_instance_group_manager.web.instance_group
    balancing_mode = "CONNECTION"

  }

  
}
