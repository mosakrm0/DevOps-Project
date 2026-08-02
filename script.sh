#!/bin/bash

GHCR_REPO="ghcr.io/mosakrm0/simpleapp"

sudo apt update -y;sudo apt upgrade -y

# Function to check command existence
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Ensure curl is installed
if ! command_exists curl; then
    sudo apt update
    sudo apt install -y curl
else
    echo "Curl already installed"
fi


# Install minikube
if ! command_exists minikube; then
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
    sudo dpkg -i minikube_latest_amd64.deb
else
    echo "Minikube already installed"
fi

# Start minikube with podman driver
sudo apt-get -y install podman

# Now deploy using image name only (no registry)
minikube config set rootless true
minikube start --driver=podman

# Install kubectl manually
KUBECTL_VERSION="v1.34.0"
if ! command_exists kubectl; then
    echo "Installing kubectl $KUBECTL_VERSION"
    curl -LO "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"

    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/
    echo "kubectl installed successfully"
else
    echo "Kubectl already installed"
fi

# Create Deployment and Service
kubectl create deployment simpleapp --image=$GHCR_REPO --replicas=3

kubectl expose deployment simpleapp --port=80 --target-port=5000 --type=LoadBalancer

sleep 10

 minikube service simpleapp
