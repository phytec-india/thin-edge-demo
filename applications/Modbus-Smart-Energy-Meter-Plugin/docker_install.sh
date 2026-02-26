#!/bin/bash

set -e

echo "=== Removing old Docker versions for conflicting perspective==="
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

echo "=== Updating packages ==="
sudo apt-get update

echo "=== Installing dependencies ==="
sudo apt-get install -y \
    apt-transport-https \
    software-properties-common \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "=== Adding Docker’s official GPG key ==="
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "=== Setting up the Docker repository ==="
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "=== Updating package index again ==="
sudo apt-get update

echo "=== Installing Docker Engine ==="
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Enabling Docker service ==="
sudo systemctl enable docker
sudo systemctl start docker

echo "=== Docker version check ==="
docker --version

echo "=== Docker Compose v2 version check ==="
docker compose version

echo "=== Verifying Docker installation ==="
sudo docker run hello-world

echo "=== Installation completed! ==="
