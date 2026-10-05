#!/bin/bash

set -e

# sudo check
if [ "$(id -u)" -ne 0 ]; then
  echo "This script must run as root."
  exit 1
fi

VENV_DIR="venv"

if [ ! -d "$VENV_DIR" ]; then
  echo "Building Python venv..."
  python3 -m venv "$VENV_DIR"
fi

PIP_PATH="./$VENV_DIR/bin/pip"
PYTHON_PATH="./$VENV_DIR/bin/python"

# upgrade pip
echo "Upgrading pip..."
"$PYTHON_PATH" -m pip install --upgrade pip

# install pip tools
"$PIP_PATH" install pwntools

# install pwndbg
if [ ! -d "pwndbg" ]; then
  echo "Cloning pwndbg..."
  git clone https://github.com/pwndbg/pwndbg
fi

cd pwndbg
echo "Running pwndbg setup..."
yes "" | ./setup.sh
cd ../

# install Docker
rm -f /etc/apt/keyrings/docker.asc /etc/apt/keyrings/docker.gpg
rm -f /etc/apt/sources.list.d/docker.list

apt-get remove -y docker docker-engine docker.io containerd runc || true

apt-get update || true
apt-get install -y ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu noble stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update || true

apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || true

# install ghidra
sudo apt update && sudo apt install -y openjdk-17-jdk
sudo snap install ghidra