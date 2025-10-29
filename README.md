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

oaoao
```
docker exec -it elasticsearch bash
/usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana
```
