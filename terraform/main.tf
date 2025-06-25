resource "google_compute_network" "vpc_network" {
  name = "vpc-webapp"
}

resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-access"]
}

resource "google_compute_firewall" "allow-monitoring" {
  name    = "allow-monitoring"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22", "9090", "3000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["monitoring"]
}


resource "google_compute_instance_template" "web_template" {
  name         = "web-app-template"
  machine_type = "e2-micro"

  tags = ["http-server", "ssh-access"]

  metadata = {
    ssh-keys = "stevenjvalle:${file("~/.ssh/id_rsa.pub")}"
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  disk {
    auto_delete  = true
    boot         = true
    source_image = "debian-cloud/debian-11"
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    # ❌ no access_config = no external IP
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}


resource "google_compute_region_instance_group_manager" "web_mig" {
  name               = "web-app-mig"
  region             = var.region
  base_instance_name = "web"

  version {
    instance_template = google_compute_instance_template.web_template.id
  }

  target_size = 2  # Number of VMs to run

  auto_healing_policies {
    health_check      = google_compute_health_check.http.id
    initial_delay_sec = 60
  }

  named_port {
    name = "http"
    port = 80
  }
}
resource "google_compute_health_check" "http" {
  name = "http-health-check"

  http_health_check {
    port         = 80
    request_path = "/"
  }

  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 3
}

resource "google_compute_backend_service" "web_backend" {
  name     = "web-backend"
  protocol = "HTTP"
  port_name = "http"
  timeout_sec = 10

  health_checks = [google_compute_health_check.http.id]

  backend {
    group = google_compute_region_instance_group_manager.web_mig.instance_group
  }
}


resource "google_compute_url_map" "web_map" {
  name = "web-url-map"

  default_service = google_compute_backend_service.web_backend.id
}

resource "google_compute_target_http_proxy" "web_proxy" {
  name    = "web-http-proxy"
  url_map = google_compute_url_map.web_map.id
}

resource "google_compute_global_forwarding_rule" "web_lb_rule" {
  name        = "web-http-rule"
  target      = google_compute_target_http_proxy.web_proxy.id
  port_range  = "80"
  ip_protocol = "TCP"
}


resource "google_compute_instance" "monitoring_vm" {
  name         = "monitoring-vm"
  machine_type = "e2-medium"
  zone         = var.zone

  tags = ["monitoring"]

  metadata = {
    ssh-keys = "stevenjvalle:${file("~/.ssh/id_rsa.pub")}"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network       = google_compute_network.vpc_network.name
    access_config {}  # assigns public IP
  }
}
