# Cloundnative Infrastructure Setup

## Typical command example(cmd = k8s-install or k8s-install-offline)
- sudo $cmd -u
  Update all related cloudnative rpms of the same baseline
- sudo $cmd -i docker -b 120
  Only Install runc/containerd/docker/docker-cli rpms of k8s 1.20 baseline
- sudo $cmd -i k8s -n master -b 120
  Only Install k8s and depended rpms as master of k8s 1.20 baseline
- sudo $cmd -d ctl2 -n master -t docker -b 120
  Install and setup k8s with given options
- sudo $cmd -c
  Destroy k8s config
- sudo $cmd -h
  Print help message

## Typical Ansible work flow
* sudo $cmd -d ctl2 -n master -t docker -b 120   On master node, and recode 'kubeadm join' output line
* sudo $cmd -d ctl2 -n worker -t docker -b 120   On each woker node, and execute 'kubeadm join' output line

## Notes
- Use k8s-install when you can reach yum and ctyun harbor by network, this is published by k8s-install rpm in yum
- Use k8s-install-offline when you can NOT reach yum or ctyun harbor by network, this is published by tgz on 124 repo
- By default it use kubeadm --init command to setup k8s. You can edit config/kubeadm-template.yaml and uncomment related lines to use config file setup
- How kubeadm.yaml came, how does it like, and what to edit:
``` shell
$ kubeadm config print init-defaults > kubeadm.yaml
$ cat kubeadm.yaml
apiVersion: kubeadm.k8s.io/v1beta2
bootstrapTokens:
- groups:
  - system:bootstrappers:kubeadm:default-node-token
  token: abcdef.0123456789abcdef
  ttl: 24h0m0s
  usages:
  - signing
  - authentication
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: 172.21.51.143  # apiserver地址，因为单master，所以配置master的节点内网IP
  bindPort: 6443
nodeRegistration:
  criSocket: unix:///var/run/containerd/containerd.sock
  imagePullPolicy: IfNotPresent
  name: k8s-master                 # 按实际情况修改
  taints:
  - effect: NoSchedule
    key: node-role.kubernetes.io/master
---
apiServer:
  timeoutForControlPlane: 4m0s
apiVersion: kubeadm.k8s.io/v1beta2
certificatesDir: /etc/kubernetes/pki
clusterName: kubernetes
controllerManager: {}
dns:
  type: CoreDNS
etcd:
  local:
    dataDir: /var/lib/etcd
imageRepository: gcs.k8s.io  # 修改成harbor仓库地址
kind: ClusterConfiguration
kubernetesVersion: v1.20.2
networking:
  dnsDomain: cluster.local
  podSubnet: 192.168.0.0/16  # Pod 网段，flannel插件需要使用这个网段
  serviceSubnet: 10.0.0.0/12
scheduler: {}
```

## Publishing
- Edit /etc/yum.repos.d/ctyunos.repo, put all available dist repos in.
- $sudo yum makecache, only refresh repo, without install.
- Run ./init.sh -b 120 in rpms tar-x86_64 and tar-aarch64 dirs to download offline stuff
- Make sure git committed all changes
- Run ./publish.sh -b 120 -d ctl2 -a x86_64 .It will sync all offline tgz to THE REPO, and change commit tgz change into obsbuild branch
