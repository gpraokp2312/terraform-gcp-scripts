# Autoscaler for the regional MIG
resource "google_compute_region_autoscaler" "web" {
  name   = "gps-autoscaler-web-mumbai"
  region = "asia-south1"
  target = google_compute_region_instance_group_manager.web.id
  
  depends_on = [
  google_compute_region_instance_group_manager.web
]
  autoscaling_policy {
    min_replicas    = 2
    max_replicas    = 2
    cooldown_period = 120  # Seconds to wait before collecting metrics from new instances

    # Scale based on CPU utilization
    cpu_utilization {
      target = 0.7  # Scale up when average CPU exceeds 70%
    }
  }
}
