#!/bin/bash

echo "==> Installing Terraform..."
winget install --id HashiCorp.Terraform

echo "==> Installing Google Cloud CLI..."
winget install -e --id Google.CloudSDK

echo "==> Installing Node.js (LTS)..."
winget install -e --id OpenJS.NodeJS.LTS

echo "==> Installing Docker Desktop..."
winget install -e --id Docker.DockerDesktop

echo "==> Installing Windows Subsystem for Linux (WSL) and Ubuntu..."
wsl --install -d Ubuntu

echo "==> Waiting for WSL to initialize..."
echo "Please complete the Ubuntu setup (username/password), then re-run this script to install Ansible."
read -p "Press Enter once Ubuntu is installed and ready..."

echo "==> Installing Ansible inside WSL Ubuntu..."
wsl bash -c "sudo apt update && sudo apt install -y ansible"

echo "==> Done! Please restart your terminal if needed."
