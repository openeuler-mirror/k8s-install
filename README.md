# Cloundnative Infrastructure Setup

## Typical command (cmd = k8s-install or k8s-install-offline)
- sudo $cmd -i docker          Only Install runc/containerd/docker/docker-cli rpms
- sudo $cmd -i k8s             Only Install runc/containerd/docker/docker-cli/k8s rpms, and load k8s images
- sudo $cmd -d ctl2 -n master -t docker      Install and setup k8s with given options
- sudo $cmd -c                 Destroy k8s config
- sudo $cmd -h                 Print help message

## Notes
- Use k8s-install when you can reach yum and ctyun harbor by network, this is published by k8s-install rpm in yum
- Use k8s-install-offline when you can NOT reach yum or ctyun harbor by network, this is published by tgz on 124 repo
- By default it use kubeadm --init command to setup k8s. You can edit config/kubeadm-template.yaml and uncomment related lines to use config file setup
- How kubeadm.yaml came, how does it like, and what to edit:
$ kubeadm config print init-defaults > kubeadm.yaml
$ cat kubeadm.yaml
``` yaml
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
  criSocket: /var/run/dockershim.sock
  name: k8s-master  #按实际情况修改
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
- Edit /etc/yum.repos.d/ctyunos.repo, put all available dist repos(ctl2&ctl3 repos in testing section) in.
- $sudo yum update, only refresh repo, without install.
- Run ./init.sh in rpms tar-x86_64 and tar-aarch64 dirs to download offline stuff
- Make sure git committed all changes
- Run ./publish.sh. It will sync all offline tgz to THE REPO, and change commit tgz change into obsbuild branch

## 离线包测试
- 下载地址：http://124.236.120.248:50001/ctyun/ctyunos/ctyunos_testing/
- 测试物：四个tgz包
- 测试流程：下载解压，执行k8s-install-offline命令，无需yum及harbor
- 测试项：看help，参考README.md，各种可能的环境情况（全裸、重装、半装），各种可能参数交叉测试
- 预期结果：可只安装、可安装加配置、可清理、可指定发行版、结点类型、容器类型。安装无缺失，配置完pod启动正常（kubectl get pods -A）

## 在线测试
- 在/etc/yum.repos.d/xxx.repo中添加测试yum源。
ctl2如下
```
[ctl2]
name=ctl2
baseurl=http://124.236.120.248:50001/ctyun/ctyunos/ctyunos-2/22.06/everything/$basearch/
enabled=1
gpgcheck=0

[ctl2-testing]
name=ctl2-testing
baseurl=http://124.236.120.248:50001/ctyun/ctyunos/ctyunos-testing-2/22.06/testing/$basearch/
enabled=1
gpgcheck=0
```
ctl3如下
```
[ctl3]
name=ctl3
baseurl=http://124.236.120.248:50001/ctyun/ctyunos/ctyunos-3/23.01-testing/everything/$basearch/
enabled=1
gpgcheck=0

[ctl3-testing]
name=ctl3-testing
baseurl=http://124.236.120.248:50001/ctyun/ctyunos/ctyunos-3/23.01-testing/update/$basearch/
enabled=1
gpgcheck=0
```
- $sudo yum update && sudo yum install k8s-install  然后执行k8s-install命令，命令模式与离线类似。如sudo k8s-install -d ctl2 -n master -t docker
- 测试项：看help，参考README.md，各种可能的环境情况（全裸、重装、半装），各种可能参数交叉测试
- 预期结果：可只安装、可安装加配置、可清理、可指定发行版、结点类型、容器类型。保证包全部能从yum安装，无缺失，可从harbor拉取镜像，所有pod在部署完成后正常运行（kubectl get pods -A）。
