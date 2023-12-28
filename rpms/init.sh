#! /bin/bash

rm -f *.rpm
rpmlist="containernetworking-plugins protobuf zlib-devel vim-filesystem vim-common libnetfilter_queue libnetfilter_cttimeout libnetfilter_cthelper gpm-libs vim-enhanced emacs-filesystem protobuf-devel protobuf-c conntrack-tools-help conntrack-tools criu socat libcgroup runc containerd docker-cli docker kubernetes-client kubernetes-kubeadm kubernetes-master kubernetes-kubelet kubernetes-node"
dist=("ctl2" "ctl3")
arch=("x86_64" "aarch64")

sudo yum makecache
for a in ${arch[@]};do
    for d in ${dist[@]};do
        yum download --repo=$d --repo=${d}-update --forcearch=$a $rpmlist
    done
done
