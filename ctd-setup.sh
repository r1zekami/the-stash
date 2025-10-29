#!/bin/bash
#containerd setup
sudo apt-get update && sudo apt-get install curl
swapoff -a

cat > /etc/modules-load.d/k8s.conf << EOF
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat > /etc/sysctl.d/k8s.conf << EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl -p /etc/sysctl.d/k8s.conf

sudo apt-get update
sudo apt-get -y install containerd

sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

sudo sed -i \
  -e 's/SystemdCgroup = false/SystemdCgroup = true/' \
  -e 's|sandbox_image = ".*"|sandbox_image = "registry.k8s.io/pause:3.10.1"|' \
  /etc/containerd/config.toml

sudo systemctl restart containerd
