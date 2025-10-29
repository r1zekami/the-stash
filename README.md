## Stash of various things that i need to save somewhere

```
sudo bash <(curl -fsSL https://get.docker.com)
```
```
curl -fsSL https://get.docker.com | sudo bash
```

containerd + k8s control plane cluster setup
```
curl -fsSL https://raw.githubusercontent.com/r1zekami/the-stash/refs/heads/main/ctd-k8s.sh | sudo bash
```
only k8s control plane cluster setup (depends on containerd)
```
curl -fsSL https://raw.githubusercontent.com/r1zekami/the-stash/refs/heads/main/k8s-cp-setup.sh | sudo bash
```
only containerd setup
```
curl -fsSL https://raw.githubusercontent.com/r1zekami/the-stash/refs/heads/main/ctd-setup.sh | sudo bash
```
Flannel
```
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```

Init and join cluster
```
sudo kubeadm init \
--control-plane-endpoint "192.168.126.128:6443" \
--pod-network-cidr=10.244.0.0/16 \
--image-repository=registry.aliyuncs.com/google_containers --v=3
```
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
