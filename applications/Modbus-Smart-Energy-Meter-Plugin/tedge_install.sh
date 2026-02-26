#!/bin/bash

set -e

echo "------------------------------------------------"
echo "Thin-Edge.io Installer Script for Debian 12"
echo "------------------------------------------------"

# 1. Update system
echo "Updating system packages..."
sudo apt update

# 2. Install dependencies
echo "Installing dependencies..."
sudo apt install -y curl apt-transport-https gnupg lsb-release

# 3. Update and install tedge
echo "Installing Thin-Edge.io..."
curl -fsSL https://thin-edge.io/install.sh | sh -s

# 4. Check installation
echo "Verifying installation..."
tedge --version

echo "Thin-Edge.io successfully installed on Debian 12."
