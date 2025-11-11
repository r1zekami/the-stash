#!/bin/sh
# use export K3S_TOKEN=yoursecret
curl -sfL https://raw.githubusercontent.com/r1zekami/the-stash/refs/heads/main/get-k3s.sh | sh -s - server --cluster-init

mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown $USER:$USER ~/.kube/config
sudo chmod 600 ~/.kube/config
echo 'export KUBECONFIG=~/.kube/config' >> ~/.bashrc
source ~/.bashrc

sudo apt update
sudo apt install -y open-iscsi nfs-common
sudo systemctl enable iscsid
sudo systemctl start iscsid

kubectl get nodes
