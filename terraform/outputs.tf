output "load_balancer_ip" {
  value = google_compute_global_forwarding_rule.web_lb_rule.ip_address
}
