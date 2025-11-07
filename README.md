## Stash of various things that i need to save somewhere

```
sudo bash <(curl -fsSL https://get.docker.com)
```
```
curl -fsSL https://get.docker.com | sudo bash
```

containerd + k8s control plane setup
```
curl -fsSL https://raw.githubusercontent.com/r1zekami/the-stash/refs/heads/main/ctd-k8s-cp.sh | sudo bash
```
containerd + k8s worker node setup
```
curl -fsSL https://raw.githubusercontent.com/r1zekami/the-stash/refs/heads/main/ctd-k8s-wrk.sh | sudo bash
```
Flannel
```
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```

Init cluster
```
sudo kubeadm init \
--control-plane-endpoint "192.168.126.128:6443" \
--pod-network-cidr=10.244.0.0/16 \
--image-repository=registry.aliyuncs.com/google_containers --v=3
```
or everything together with flannel
```
sudo kubeadm init --control-plane-endpoint "192.168.126.128:6443" --pod-network-cidr=10.244.0.0/16  --image-repository=registry.aliyuncs.com/google_containers --v=3;mkdir -p $HOME/.kube;sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config;sudo chown $(id -u):$(id -g) $HOME/.kube/config;kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```
join cluster
```
sudo kubeadm join 192.168.126.128:6443 \
    --token {token} \
	--discovery-token-ca-cert-hash {sha256hash} \
	--certificate-key {cert.key} \
	--control-plane \
	--v=3
```

oaoao
```
docker exec -it elasticsearch bash
/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana
```
