# Cloundnative Infrastructure Setup

## Typical command (cmd = k8s-install or k8s-install-offline)
- sudo $cmd -i docker          Only Install runc/containerd/docker/docker-cli rpms
- sudo $cmd -i k8s -n master   Only Install runc/containerd/docker/docker-cli/k8s rpms, must specify node type
- sudo $cmd -d ctl2 -n master -t docker      Install and setup k8s with given options
- sudo $cmd -c                 Destroy k8s config
- sudo $cmd -h                 Print help message

## Typical Ansible work flow
* sudo $cmd -d ctl2 -n master -t docker   On master node, and recode 'kubeadm join' output line
* sudo $cmd -d ctl2 -n worker -t docker   On each woker node, and execute 'kubeadm join' output line

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
- Edit /etc/yum.repos.d/ctyunos.repo, put all available dist repos in.
- $sudo yum makecache, only refresh repo, without install.
- Run ./init.sh in rpms tar-x86_64 and tar-aarch64 dirs to download offline stuff
- Make sure git committed all changes
- Run ./publish.sh. It will sync all offline tgz to THE REPO, and change commit tgz change into obsbuild branch

## 离线包测试
- 下载地址：https://cloud.189.cn/t/aiUVrevEZFFn （访问码：y2ul）
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
baseurl=https://ctyunos.ctyun.cn/hostos/ctyunos-22.06/everything/$basearch/
enabled=1
gpgcheck=0
priority=10

[ctl2-update]
name=ctl2-update
baseurl=https://ctyunos.ctyun.cn/hostos/ctyunos-22.06/update/$basearch/
enabled=1
gpgcheck=0
priority=1
```
ctl3如下
```
[ctl3]
name=ctl3
baseurl=https://ctyunos.ctyun.cn/hostos/ctyunos-23.01/everything/$basearch/
enabled=1
gpgcheck=0
priority=20

[ctl3-update]
name=ctl3-update
baseurl=https://ctyunos.ctyun.cn/hostos/ctyunos-23.01/update/$basearch/
enabled=1
gpgcheck=0
priority=20
```
- $sudo yum makecache && sudo yum install k8s-install  然后执行k8s-install命令，命令模式与离线类似。如sudo k8s-install -d ctl2 -n master -t docker
- 测试项：看help，参考README.md，各种可能的环境情况（全裸、重装、半装），各种可能参数交叉测试
- 预期结果：可只安装、可安装加配置、可清理、可指定发行版、结点类型、容器类型。保证包全部能从yum安装，无缺失，可从harbor拉取镜像，所有pod在部署完成后正常运行（kubectl get pods -A）。
