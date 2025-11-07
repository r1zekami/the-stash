#!/bin/bash
#containerd setup
swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

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
  -e 's#/usr/lib/cni#/opt/cni/bin#g' \
  /etc/containerd/config.toml

sudo systemctl restart containerd

#k8s worker node setup

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

sudo mkdir -p -m 755 /etc/apt/keyrings #optional
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list

sudo apt install -y ufw
sudo ufw allow 10250/tcp        #kubelet
sudo ufw allow 10255/tcp        #ro kubelet
sudo ufw allow 30000:32767/tcp  #NodePort services
sudo ufw allow 4789/udp         #VXLAN (Flannel)
sudo ufw allow 22/tcp           #ssh

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

sudo systemctl enable kubelet

sudo mkdir -p /opt/cni/bin
curl -L https://github.com/containernetworking/plugins/releases/download/v1.7.1/cni-plugins-linux-amd64-v1.7.1.tgz | sudo tar -C /opt/cni/bin -xz

echo "Enable firewall: ufw enable"
