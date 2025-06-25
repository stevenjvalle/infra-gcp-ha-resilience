output "load_balancer_ip" {
  value = google_compute_global_forwarding_rule.web_lb_rule.ip_address
}
output "monitoring_vm_ip" {
  value = google_compute_instance.monitoring_vm.network_interface[0].access_config[0].nat_ip
}
