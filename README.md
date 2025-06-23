# infra-gcp-ha-resilience
#  Resilient Web App Infrastructure on GCP

This project details a highly available, single-zone web app infrastructure on Google Cloud Platform using **Terraform** for infrastructure and **Nginx** as a simple HTTP server.

> 🔐 SSH and HTTP access are automatically configured. Startup script installs and runs Nginx.

---

##  Tech Stack

- **Terraform** – Infra as Code
- **GCP Compute Engine** – Virtual machines
- **GCP Firewall Rules** – HTTP + SSH access
- **Custom VPC** – Isolated network
- **Startup Script** – Configures Nginx on boot

---

##  What It Does

- Creates a VPC and firewall rules
- Launches a VM (`e2-micro`) in a specified zone
- Injects your SSH public key for secure login
- Installs and runs Nginx via a startup script
- Outputs the VM’s public IP for web access


##  Prerequisites
A GCP Project with billing enabled

gcloud CLI installed + authenticated

`gcloud auth application-default login`

terraform installed

An SSH key at ~/.ssh/id_rsa.pub

## Usage
cd terraform

# Initialize Terraform
terraform init

# Apply the infrastructure
terraform apply -var="project_id=your-gcp-project-id"