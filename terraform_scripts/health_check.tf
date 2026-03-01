# HTTP health check
resource "google_compute_region_health_check" "web" {
  name                = "gps-hc-web-http"
  check_interval_sec  = 10
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/healthz"
  }
}
