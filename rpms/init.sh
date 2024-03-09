#! /bin/bash
build_version=$1
source ../variable.sh 
version_function="set_version_${build_version}"
if declare -f "$version_function" > /dev/null; then
    $version_function
else
    echo "Version function $version_function not found. Exiting."
    exit 1
fi

rm -f *.rpm
#rpmlist="containernetworking-plugins protobuf zlib-devel vim-filesystem vim-common libnetfilter_queue libnetfilter_cttimeout libnetfilter_cthelper gpm-libs vim-enhanced emacs-filesystem protobuf-devel protobuf-c conntrack-tools-help conntrack-tools criu socat libcgroup runc containerd docker-cli docker kubernetes-client kubernetes-kubeadm kubernetes-master kubernetes-kubelet kubernetes-node"
rpmlist="protobuf zlib-devel vim-filesystem vim-common libnetfilter_queue libnetfilter_cttimeout libnetfilter_cthelper gpm-libs vim-enhanced emacs-filesystem protobuf-devel protobuf-c conntrack-tools-help conntrack-tools socat"
rpmlist_cloud="criu libcgroup runc containerd docker-cli docker kubernetes-kubelet kubernetes-client kubernetes-node kubernetes-kubeadm kubernetes-master containernetworking-plugins"
dist=("ctl2" "ctl3")
arch=("x86_64" "aarch64")

sudo yum makecache
for a in ${arch[@]};do
    for d in ${dist[@]};do
        yum download --repo=$d --repo=${d}-update --forcearch=$a $rpmlist
        for pkg in $rpmlist_cloud; do
            version_var=$(echo "${package^^}" | tr '-' '_')_VERSION  # Convert package name to uppercase and append _VERSION
            version_var=${!version_var}                 # Dereference to get the version
            if [[ ! -z "$version_var" ]]; then
                yum download --repo=$d --repo=${d}-update --forcearch=$a "${pkg}-${version_var}"
            else
                echo "No version specified for $pkg, skipping..."
            fi
        done
    done
done
