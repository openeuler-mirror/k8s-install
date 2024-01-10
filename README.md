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

## 参数说明
### 输入参数 -u
- 不需要额外参数，单独使用。代表在同一基线内升级所有安装过的云原生相关的软件包，通常是为了进行封堵安全漏洞

### 输入参数 -i
- 需要额外参数，可组合使用
- 可选值 docker：代表只安装docker及其依赖。
- 可选值 k8s：代表只安装k8s及其依赖，并加载所需要镜像。

### 输入参数 -d
- 需要额外参数，可组合使用
- 可选值 ctyunos2:代表按照ctyunos2系统基线进行安装配置。
- 可选值 ctyunos3:代表按照ctyunos3系统基线进行安装配置。
- 可能增加更多的可选值，即更多的操作系统支持。(TODO)

### 输入参数 -n
- 需要额外参数，可组合使用
- 可选值 master:代表按照ctyunos2系统基线进行安装配置。
- 可选值 node:代表按照ctyunos3系统基线进行安装配置。

### 输入参数 -t
- 需要额外参数，可组合使用
- 可选值 containerd:代表k8s使用containerd做为容器运行时进行配置。
- 可选值 docker:代表k8s使用docker做为容器运行时进行配置。
- 可能增加更多的可选值，即更多的容器类型支持，如isulad、podman。(TODO)

### 输入参数 -b
- 需要额外参数，可组合使用
- 可选值 120:代表使用k8s 1.20基线内的软件包。
- 可选值 125:代表使用k8s 1.25基线内的软件包。(TODO)
- 可选值 129:代表使用k8s 1.29基线内的软件包。(TODO)

### 输入参数 -c
- 清除k8s现有的集群，以及所有配置，仅当集群无法修复或准备重新初始化时才推荐使用。

### 输入参数 -h
- 打印帮助信息。

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
