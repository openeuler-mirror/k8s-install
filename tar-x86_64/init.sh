#! /bin/bash

rm -f *.tar

# pull docker images.
docker pull docker.ctyun.cn:60001/base-x86_64/flannel:v0.21.0
docker pull docker.ctyun.cn:60001/base-x86_64/flannel-cni-plugin:v1.1.2
docker pull docker.ctyun.cn:60001/base-x86_64/kube-proxy:v1.20.2
docker pull docker.ctyun.cn:60001/base-x86_64/kube-apiserver:v1.20.2
docker pull docker.ctyun.cn:60001/base-x86_64/kube-controller-manager:v1.20.2
docker pull docker.ctyun.cn:60001/base-x86_64/kube-scheduler:v1.20.2
docker pull docker.ctyun.cn:60001/base-x86_64/etcd:3.4.13-0
docker pull docker.ctyun.cn:60001/base-x86_64/coredns:1.7.0
docker pull docker.ctyun.cn:60001/base-x86_64/pause:3.2

# save docker images to tar.
docker save docker.ctyun.cn:60001/base-x86_64/flannel:v0.21.0  -o flannel.tar
docker save docker.ctyun.cn:60001/base-x86_64/flannel-cni-plugin:v1.1.2 -o flannel-cni-plugin.tar
docker save docker.ctyun.cn:60001/base-x86_64/kube-proxy:v1.20.2  -o kube-proxy.tar
docker save docker.ctyun.cn:60001/base-x86_64/kube-apiserver:v1.20.2  -o kube-apiserver.tar
docker save docker.ctyun.cn:60001/base-x86_64/kube-controller-manager:v1.20.2  -o kube-controller-manager.tar
docker save docker.ctyun.cn:60001/base-x86_64/kube-scheduler:v1.20.2  -o kube-scheduler.tar
docker save docker.ctyun.cn:60001/base-x86_64/etcd:3.4.13-0  -o etcd.tar
docker save docker.ctyun.cn:60001/base-x86_64/coredns:1.7.0  -o coredns.tar
docker save docker.ctyun.cn:60001/base-x86_64/pause:3.2  -o pause.tar
