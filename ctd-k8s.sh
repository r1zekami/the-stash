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

#k8s control plane init

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg

sudo mkdir -p -m 755 /etc/apt/keyrings #optional
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list

sudo apt install -y ufw
sudo ufw allow 6443/tcp         #kubeapiserver
sudo ufw allow 2379:2380/tcp    #etcd
sudo ufw allow 10250:10252/tcp  #kubelet
sudo ufw allow 10255/tcp        #ro kubelet
sudo ufw allow 10257/tcp        #controller-manager ?
sudo ufw allow 10259/tcp        #scheduler ?
sudo ufw allow 4789/udp         #VXLAN (Flannel)
sudo ufw enable

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

sudo systemctl enable kubelet

sudo mkdir -p /usr/lib/cni
curl -L https://github.com/containernetworking/plugins/releases/download/v1.4.0/cni-plugins-linux-amd64-v1.4.0.tgz | sudo tar -C /usr/lib/cni -xz

#sudo kubeadm init --pod-network-cidr=10.244.0.0/16 --image-repository=registry.aliyuncs.com/google_containers --v=3
#kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
#kubectl taint nodes --all node-role.kubernetes.io/control-plane-
