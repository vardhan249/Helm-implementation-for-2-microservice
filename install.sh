#!/bin/bash
set -e

# Install k3s
echo "Installing k3s..."
if ! command -v k3s &> /dev/null; then
    curl -sfL https://get.k3s.io | sh -
else
    echo "k3s already installed, skipping..."
fi

# Wait for k3s to start
echo "Waiting for k3s to be ready..."
sleep 10

# Verify nodes
echo "Checking k3s nodes..."
sudo k3s kubectl get nodes

# Install Helm
echo "Installing Helm..."
if ! command -v helm &> /dev/null; then
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
else
    echo "Helm already installed, skipping..."
fi

# Configure kubeconfig
echo "Setting up kubeconfig..."
mkdir -p $HOME/.kube
sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Install Metrics Server
echo "Deploying metrics-server..."
if ! sudo k3s kubectl get deployment metrics-server -n kube-system &>/dev/null; then
    sudo k3s kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
else
    echo "metrics-server already deployed, skipping..."
fi

# Patch metrics-server for insecure TLS
echo "Patching metrics-server for --kubelet-insecure-tls..."
sudo k3s kubectl patch deployment metrics-server -n kube-system \
    --type='json' \
    -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'

# Verify Helm installation
echo "Verifying Helm installation..."
helm version

echo "k3s, Helm, and metrics-server installation completed successfully!"
