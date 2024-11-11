# k8s-install使用手册

## 一、支持范围

**k8s-install支持以下操作系统和k8s版本的安装：**

| **操作系统**                                                 | **Kubernetes**版本             | **容器运行时**          |
| ------------------------------------------------------------ | ------------------------------ | ----------------------- |
| **openEuler24.03LTS \| ctyunos4系列**                        | **1.29.1**                     | **仅containerd**        |
| **openEuler23.09**                                          | **1.29.1 \| 1.25.3**           | **仅containerd**        |
| **openEuler22.03LTS \| ctyunos3系列**                        | **1.29.1 \| 1.25.3 \| 1.20.2** | **containerd/docker*** |
| **openEuler20.03LTS \| ctyunos2系列**                        | **1.29.1 \| 1.25.3 \| 1.20.2** | **containerd/docker*** |
| ***注：k8s版本1.29.1，1.25.3仅支持containerd，1.20.2支持containerd或docker** |                                |                         |

## **二、** **基础使用说明**

### 1.  **参数说明**

**k8s-inatll和k8s-install-offline脚本参数说明：**

`-i  `: 仅安装到某一步为止。需要额外参数，可与其它参数组合使用。

&emsp;&emsp;&emsp;&emsp;可选值有`docker` 或 `k8s`

&emsp;&emsp;&emsp;&emsp;``docker`` : 仅安装并运行docker

&emsp;&emsp;&emsp;&emsp;``k8s`` : 仅安装k8s相关rpm和所需依赖，加载必要镜像

&emsp;&emsp;&emsp;&emsp;不使用``-i`` : 安装并完成部署k8s（执行kubeadm init）

``-d`` : 当前操作系统版本。需要额外参数，可与其它参数组合使用。

&emsp;&emsp;&emsp;&emsp;可选值有`oe2403`  `oe2309`  `ctl4`  `ctl3`  `ctl2` （oe2203 oe2003暂未支持）

&emsp;&emsp;&emsp;&emsp;`oe2403` : 代表按照`openEuler-24.03-LTS`系统基线进行安装配置

&emsp;&emsp;&emsp;&emsp;`oe2309`: 代表按照`openEuler-23.09`系统基线进行安装配置

&emsp;&emsp;&emsp;&emsp;`ctl4`: 代表按照`ctyunos4系列（比如24.06）`系统基线进行安装配置

&emsp;&emsp;&emsp;&emsp;`ctl3`: 代表按照`ctyunos3系列（比如23.01）`系统基线进行安装配置

&emsp;&emsp;&emsp;&emsp;`ctl2`: 代表安装`ctyunos2系列（比如22.06）`系统基线进行安装配置

``-b`` : 指定安装的k8s基线版本。需要额外参数，可与其它参数组合使用。

&emsp;&emsp;&emsp;&emsp;可选值有`120`  `125`  `129` （不同操作系统版本可使用基线见上面的支持范围）

&emsp;&emsp;&emsp;&emsp;`120`:代表使用k8s 1.20基线内的软件包(v1.20.2)。

​&emsp;&emsp;&emsp;&emsp;`125`:代表使用k8s 1.25基线内的软件包(v1.25.3)。

​&emsp;&emsp;&emsp;&emsp;`129`:代表使用k8s 1.29基线内的软件包(v1.29.1)。

`-t `: k8s的容器运行时。需要额外参数，可与其它参数组合使用。

&emsp;&emsp;&emsp;&emsp;可选值有`docker`  `containerd` （不同基线可使用运行时见上面的支持范围）

&emsp;&emsp;&emsp;&emsp;`containerd`:代表k8s使用containerd做为容器运行时进行配置。

&emsp;&emsp;&emsp;&emsp;`docker`:代表k8s使用docker做为容器运行时进行配置。

`-n`: 安装的节点角色。需要额外参数，可与其它参数组合使用。

​&emsp;&emsp;&emsp;&emsp;可选值有 `master`  `worker`

​&emsp;&emsp;&emsp;&emsp;`master`:代表按照k8s的master节点进行安装配置。

​&emsp;&emsp;&emsp;&emsp;`worker`:代表按照k8s的worker节点进行安装配置。

`-u`: 不需要额外参数，单独使用。代表在同一基线内升级所有安装过的云原生相关的软件包，通常是为了进行封堵安全漏洞。

`-c`: 清除k8s现有集群的所有配置，仅当集群无法修复或准备重新初始化时才推荐使用。

`-h`: 打印帮助信息。

### 2. 在线安装

#### （1）**安装k8s-install软件包**

- 配置好已发布k8s-install包的软件源，例如在ctyunos3上要添加
  `https://repo.ctyun.cn/hostos/ctyunos-23.01/update/$basearch`

- 执行安装命令

```bash
yum make cache;yum install -y k8s-install
```

 - 删除不想使用的旧软件包（如果不删除，则会继续使用老版本，推荐删除）

 ```bash
yum autoremove runc containerd docker kubectl kubeadm
 ```

#### （2）**仅安装docker(moby)**

```bash
./k8s-install -i docker -d xxx -b xxx 
```

示例1：在一台`openEuler-24.03-LTS` 机器上仅安装`129`基线的`docker(moby)`，指令如下

```bash
./k8s-install -i docker -b 129 -d oe2403
```

#### （3）**仅安装k8s依赖和所需镜像**

```bash
./k8s-install -i k8s -b xxx -d xxx -t xxx -n xxx
```

示例2：在一台 `openEuler-24.03-LTS` 机器上仅安装`129`基线`master`节点所需依赖和镜像，指令如下

```bash
./k8s-install -i k8s -d oe2403 -b 129 -t containerd -n master
```

#### （4）**安装并部署k8s**

```bash
./k8s-install -b xxx -d xxx -t xxx -n xxx
```

示例3：在一台 `openEuler-24.03-LTS` 机器上安装并部署`129`基线，容器运行时为containerd的`master`节点，，指令如下

```bash
./k8s-install -b 129 -d oe2403 -t containerd -n master
```

### 3. 离线安装

#### （1）下载离线rpm包和镜像

- 网盘下载：https://cloud.189.cn/web/share?code=jUrIzer2AZJ3（访问码：5tn5）

#### （2）离线部署

- 解压并替换脚本文件夹中的rpm和tar-x86_64（或tar-aarch64）文件夹

- 删除不想使用的旧软件包（如果不删除，则会继续使用老版本，推荐删除）

 ```bash
yum autoremove runc containerd docker kubectl kubeadm
 ```

- 执行k8s-install-offline：（参数同在线安装）

 ```bash
 ./k8s-install-offline -d xxx -b xxx -t xxx -n xxx
 ```

## 三、多节点部署示例

### **1. 配置规划**

| **主机名**      | **IP地址**      | **角色**   | **规格** | 操作系统                |
| --------------- | ---------------- | ---------- | -------- | ----------------------- |
| **k8s-master**  | **192.168.1.20** | **master** | **4C8G** | **openEuler-24.03-LTS** |
| **k8s-worker1** | **192.168.1.21** | **worker** | **4C8G** | **openEuler-24.03-LTS** |
| **k8s-worker2** | **192.168.1.22** | **worker** | **4C8G** | **openEuler-24.03-LTS** |

### **2. 安装时间同步服务**

**确保三台服务器时间准确，三台服务器都要需要执行**

```bash
yum -y install chrony
systemctl start chronyd && systemctl enable chronyd
```

### **3. 修改hosts**

**在三台机器上都需要操作**

```bash
cat >> /etc/hosts << EOF
192.168.1.20 k8s-master
192.168.1.21 k8s-worker1
192.168.1.22 k8s-worker2
EOF
```

### **4. 转发IPv4并让iptables看到桥接流量**

**三台服务器都要需要执行**

```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf 
overlay 
br_netfilter 
EOF 

modprobe overlay 
modprobe br_netfilter 

# 设置所需的 sysctl 参数 
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf 
net.bridge.bridge-nf-call-iptables = 1 
net.bridge.bridge-nf-call-ip6tables = 1 
net.ipv4.ip_forward = 1     
EOF 

sed -i 's/net.ipv4.ip_forward=0/net.ipv4.ip_forward=1/g' /etc/sysctl.conf 

# 应用 sysctl 参数 
sysctl --system 

# 检验配置是否生效 
lsmod | grep br_netfilter 
lsmod | grep overlay 
 
sysctl net.bridge.bridge-nf-call-iptables net.bridge.bridge-nf-call-ip6tables net.ipv4.ip_forward
```

### 5. **k8s-master: 部署master节点**

- 在线或离线部署k8s-1.29 的master节点：

  ```bash
  ./k8s-install -d oe2403 -b 129 -t containerd -n master 
  ```

- 出现 **"Your Kubernetes contro-plane has initialized successfully!"** 字样表示部署成功

- 复制并界面显示的kubeadm join指令

  ```bash
  kubeadm join 192.168.xx.xx:6443 --token xxxxxxx \
  	--discovery-token-ca-cert-hash sha256:xxxxxxxxxxx
  ```

### **6. k8s-worker1 & k8s-worker2: 部署worker节点**

- 通过在线或离线部署**仅安装k8s**所需依赖和镜像：

  ```bash
  ./k8s-install -i k8s -d ctl3 -b 129 -t containerd -n worker
  ```

  或者：

  ```shell
  ./k8s-install-offline -i k8s -d ctl3 -b 129 -t containerd -n worker
  ```

- 安装完成后执行如下指令：

  ```shell
  kubeadm reset -f
  
  # k8s-master机器上复制的join指令
  kubeadm join 192.168.xx.xx:6443 --token xxxxxxx \
  	--discovery-token-ca-cert-hash sha256:xxxxxxxxxxx
  ```

- 出现 **"This node has joined the cluster"** 字样则部署成功，在master结点上使用kubectl label node命令设定结点角色

  ```shell
   kubectl label node k8s-worker1 node-role.kubernetes.io/master
  node/worker1 labeled
   kubectl label node k8s-worker2 node-role.kubernetes.io/master
  node/worker2 labeled
  ```

- 说明：如果需要增加额外的master结点，也需要使用同样的方法先join进集群，再在master结点上使用kubectl label node命令设定结点角色。例如：

  ```shell
   kubectl label node master2 node-role.kubernetes.io/master
  node/master2 labeled
  ```


## **三、发布工具介绍**

### 1. publish.sh脚本

&emsp;&emsp;该工具的作用是一键更新软件包、镜像、配置文件，并分别打包发布离线包和在线包。将最新的代码脚本、rpm、镜像、配置封装在一起，生成在线rpm安装包，并进行编译测试（后续还可以串联上传到obs服务器进行正式编译，并发布到yum源）；生成离线tgz安装包并推送到网盘进行存储。
Publish.sh是发布器的主程序脚本，rpms、tar-aarch64、tar-x8_64这三个文件夹下有各自的初始化及更新脚本，用以拉取最新的rpm软件包及各架构对应的容器镜像。可被开发人员触发的publish.sh调用。

**参数说明**

`-b` :  必须，需要额外参数。意义和用法与k8s-install的这个参数相同

​&emsp;&emsp;&emsp;&emsp;可选值有`120`  `125`  `129`

`-d`: 必须，需要额外参数。意义和用法与k8s-install的这个参数相同

&emsp;&emsp;&emsp;&emsp;可选值有`oe2403`  `oe2309`  `ctl4`  `ctl3`  `ctl2` 

`-a`: 必须，需要额外参数。指定需要发布的架构

​&emsp;&emsp;&emsp;&emsp;可选值有`x86_64` `aarch64`

​&emsp;&emsp;&emsp;&emsp;`x86_64`:代表下载发布`x86_64`系统架构的镜像包

​&emsp;&emsp;&emsp;&emsp;`aarch64`:代表下载发布`aarch64`系统架构的镜像包

### 2. 配置网盘

- **配置坚果云网盘（仅首次需要）**
  ​		登录坚果云 --> 点击右上角用户名 --> 账户信息 --> 安全选项 --> 添加应用 --> 复制应用密码  

- **设置坚果云网盘账号密码**

```bash
cd config

#vim jianguoyun.config
#vim 修改文件中的username和password或者执行下面指令

sed -i 's/^username=.*/username="xxxxxx"/' jianguoyun.config  #xxxx改为账号
sed -i 's/^password=.*/password="xxxxxx"/' jianguoyun.config  #xxxx改为应用密码(注：不是坚果云登录密码)
```

### 3. 执行pulish.sh

```bash
#执行时三个参数都必须输入
./publish.sh -b xxx -d xxx -a xxx  
```

示例：

```bash
./publish.sh -b 125 -d oe2309 -a x86_64
```

**打包结果验证：**

- 检查坚果云`k8s-install-rpms/oe2309/125`路径下是否有`x86_64.tgz`压缩包。

- 下载解压：文件夹中应包含`config` `rpms` `tar-x86_64` `k8s-install-offline` `README.md` `variable.sh` 

## 四、用户可配置文件说明

### 1. 配置文件位置

- **对于在线安装场景**，配置文件会被安装到/etc/k8s-install目录中
- **对于离线安装场景**，所有配置文件在解开的压缩包的config目录中

### 2. repo文件

- **repo文件为在线安装脚本k8s-install使用的临时源文件**，如需要可以替换为其他镜像站（当前为华为）
  ​	镜像仓库列表地址：[openEuler镜像仓列表 ](https://www.openeuler.org/zh/mirror/list/)

​	更改示例：

```bash
cd config

#将openEuler2403.repo从华为替换为网易镜像站
sed -i 's/repo\.huawei\.com/mirrors.163.com/g' openEuler2403.repo 

#更新
yum clean all && yum makecache
```

### 3. flannel.yaml

**若不使用默认的flannel，需要将flannel.yaml中image地址与所使用的flannel镜像tag改为一致**

```shell
  #flannel.yaml(部分)
  	   
       image: registry.cn-hangzhou.aliyuncs.com/k8s-install-flannel/flannel:v0.25.1  #需修改flannel镜像地址，与镜像tag一致
        name: kube-flannel
        resources:
          requests:
            cpu: 100m
            memory: 50Mi
        securityContext:
          capabilities:
            add:
            - NET_ADMIN
            - NET_RAW
          privileged: false
        volumeMounts:
        - mountPath: /run/flannel
          name: run
        - mountPath: /etc/kube-flannel/
          name: flannel-cfg
        - mountPath: /run/xtables.lock
          name: xtables-lock
      hostNetwork: true
      initContainers:
      - args:
        - -f
        - /flannel
        - /opt/cni/bin/flannel
        command:
        - cp
        image: registry.cn-hangzhou.aliyuncs.com/k8s-install-flannel/flannel-cni-plugin:v1.4.1-flannel1  #需修改flannel-cni-plugins镜像地址，与镜像tag一致
        name: install-cni-plugin
        volumeMounts:
        - mountPath: /opt/cni/bin
          name: cni-plugin
      - args:
        - -f
        - /etc/kube-flannel/cni-conf.json
        - /etc/cni/net.d/10-flannel.conflist
        command:
        - cp
        image: registry.cn-hangzhou.aliyuncs.com/k8s-install-flannel/flannel:v0.25.1  #需修改flannel镜像地址，与镜像tag一致
        name: install-cni
        volumeMounts:
        - mountPath: /etc/cni/net.d
          name: cni
        - mountPath: /etc/kube-flannel/
          name: flannel-cfg
```

**同时需要修改variable.sh中flannel版本，以及k8s-install脚本中flannel下载地址**

```shell
#variable.sh（部分）

set_version_129(){    									 #以129为例,120,125相同
    # images version
    export FLANNEL_VERSION="v0.25.1"   					 #修改flannel版本号
    export FLANNEL_CNI_PLUGIN_VERSION="v1.4.1-flannel1"  #修改flannel-cni-plugins版本号
    export KUBE_PROXY_VERSION="v1.29.1"
    export KUBE_CONTROLLER_MANAGER_VERSION="v1.29.1"
    export KUBE_APISERVER_VERSION="v1.29.1"
    export KUBE_SCHEDULER_VERSION="v1.29.1"
    export ETCD_VERSION="3.5.10-0"
    export COREDNS_VERSION="v1.11.1"
    export PAUSE_VERSION="3.9"
```

```shell
#k8s-install(部分)

#!/bin/bash
set -e
source variable.sh
imagerepo=$IMAGE_REPO
imagerepo=registry.aliyuncs.com/google_containers
imageflnrepo=registry.cn-hangzhou.aliyuncs.com/k8s-install-flannel    #修改flannel镜像下载地址
podnetwork=10.244.0.0/16
usedocker=1
usetemprepo=0
ip=$(hostname -I | awk '{print $1}')
name=$(hostname)
basearch=$(arch)
```

### 4. daemon.json

daemon.json为docker配置文件，若有需要可修改并替换docker的默认配置文件。

修改：

```shell
#daemon.json

{
  "builder": {
    "gc": {
      "defaultKeepStorage": "20GB",
      "enabled": true
    }
  },
  "experimental": false,
  "features": {
    "buildkit": true
  },
  "insecure-registries": [                           #可以在此处添加或修改镜像hubor地址
    "docker.ctyun.cn:60001",
    "docker-hb02.ctyun.cn:60001",
    "artifactory.k8s.gz3.ctyun.cn:31344"
  ]
}
```

替换：

```bash
mkdir -p /etc/docker
cp config/daemon.json /etc/docker/daemon.json --update
```



### 5. kubeadm-template.yaml

kubeadm-template.yaml 用于config方式部署kubernetes。使用前请按如下建议手动修改文件，再执行` kubeadm init --config kubeadm-template.yaml`进行部署。

```shell
#kubeadm-template.yaml

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
kubernetesVersion: v1.20.2	 # 修改成要部署的k8s版本
networking:
  dnsDomain: cluster.local
  podSubnet: 192.168.0.0/16  # Pod 网段，flannel插件需要使用这个网段
  serviceSubnet: 10.0.0.0/12
scheduler: {}
```

### 6. jianguoyun.config

**坚果云配置文件可以增删改baseline，dist，以及修改username和password**

```shell
#jianguoyun.config 

#! /bin/bash
baseline=("120" "125" "129")                     #可以增删改baseline列表内容
dist=("ctl2" "ctl3" "ctl4" "oe2309" "oe2403")	 #可以增删改dist列表内容
username="xxxxxx"					 			 #填写用户名
password="xxxxxx"								 #填写密码

echo "开始配置坚果云"
echo "创建远端目录.."

#创建目录可根据需要进行修改，如下：
#curl -u "${username}:${password}" -X MKCOL "https://dav.jianguoyun.com/dav/新目录"
#curl -u "${username}:${password}" -X MKCOL "https://dav.jianguoyun.com/dav/新目录/新子目录"
```

## 五、测试方式
### 1. 离线包测试
- 下载地址：https://cloud.189.cn/t/aiUVrevEZFFn （访问码：y2ul）
- 测试物：四个tgz包
- 测试流程：下载解压，执行k8s-install-offline命令，无需yum及harbor
- 测试项：看help，参考README.md，各种可能的环境情况（全裸、重装、半装），各种可能参数交叉测试
- 预期结果：可只安装、可安装加配置、可清理、可指定发行版、结点类型、容器类型。安装无缺失，配置完pod启动正常（kubectl get pods -A）

### 2. 在线测试
- 在/etc/yum.repos.d/xxx.repo中添加测试yum源（新建或复制config文件中的.repo文件）。
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
