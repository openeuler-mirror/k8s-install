set_version_120(){
    # images version
    export FLANNEL_VERSION="v0.21.0"
    export FLANNEL_CNI_PLUGIN_VERSION="v1.1.2"
    export KUBE_PROXY_VERSION="v1.20.2"
    export KUBE_CONTROLLER_MANAGER_VERSION="v1.20.2"
    export KUBE_APISERVER_VERSION="v1.20.2"
    export KUBE_SCHEDULER_VERSION="v1.20.2"
    export ETCD_VERSION="3.4.13-0"
    export COREDNS_VERSION="1.7.0"
    export PAUSE_VERSION="3.2"

    # pkg version
    export CRIU_VERSION="3.16.1"
    export LIBCGROUP_VERSION="0.42.2"
    export RUNC_VERSION="1.1.12"
    export CONTAINERD_VERSION="1.5.6"
    export DOCKER_CLI_VERSION="20.10.12"
    export DOCKER_VERSION="20.10.12"
    export KUBERNETES_KUBELET_VERSION="1.20.2"
    export KUBERNETES_CLIENT_VERSION="1.20.2"
    export KUBERNETES_NODE_VERSION="1.20.2"
    export KUBERNETES_KUBEADM_VERSION="1.20.2"
    export KUBERNETES_MASTER_VERSION="1.20.2"
    export CONTAINERNETWORKING_PLUGINS_VERSION="1.1.1"
}

set_version_125(){
    # images version
    export FLANNEL_VERSION=""
    export FLANNEL_CNI_PLUGIN_VERSION=""
    export KUBE_PROXY_VERSION=""
    export KUBE_CONTROLLER_MANAGER_VERSION=""
    export KUBE_APISERVER_VERSION=""
    export KUBE_SCHEDULER_VERSION=""
    export ETCD_VERSION=""
    export COREDNS_VERSION=""
    export PAUSE_VERSION=""

    # pkg version
    export CRIU_VERSION=""
    export LIBCGROUP_VERSION=""
    export RUNC_VERSION=""
    export CONTAINERD_VERSION=""
    export DOCKER_CLI_VERSION=""
    export DOCKER_VERSION=""
    export KUBERNETES_KUBELET_VERSION=""
    export KUBERNETES_CLIENT_VERSION=""
    export KUBERNETES_NODE_VERSION=""
    export KUBERNETES_KUBEADM_VERSION=""
    export KUBERNETES_MASTER_VERSION=""
    export CONTAINERNETWORKING_PLUGINS_VERSION=""
}

set_version_129(){
    # images version
    export FLANNEL_VERSION=""
    export FLANNEL_CNI_PLUGIN_VERSION=""
    export KUBE_PROXY_VERSION=""
    export KUBE_CONTROLLER_MANAGER_VERSION=""
    export KUBE_APISERVER_VERSION=""
    export KUBE_SCHEDULER_VERSION=""
    export ETCD_VERSION=""
    export COREDNS_VERSION=""
    export PAUSE_VERSION=""

    # pkg version
    export CRIU_VERSION=""
    export LIBCGROUP_VERSION=""
    export RUNC_VERSION=""
    export CONTAINERD_VERSION=""
    export DOCKER_CLI_VERSION=""
    export DOCKER_VERSION=""
    export KUBERNETES_KUBELET_VERSION=""
    export KUBERNETES_CLIENT_VERSION=""
    export KUBERNETES_NODE_VERSION=""
    export KUBERNETES_KUBEADM_VERSION=""
    export KUBERNETES_MASTER_VERSION=""
    export CONTAINERNETWORKING_PLUGINS_VERSION=""
}


export IMAGE_REPO="docker.ctyun.cn:60001"
#export offline_rpmlist="containernetworking-plugins protobuf zlib-devel vim-filesystem vim-common libnetfilter_queue libnetfilter_cttimeout libnetfilter_cthelper gpm-libs vim-enhanced emacs-filesystem protobuf-devel protobuf-c conntrack-tools-help conntrack-tools criu socat libcgroup runc containerd docker-cli docker kubernetes-client kubernetes-kubeadm kubernetes-master kubernetes-kubelet kubernetes-node"
export online_install_pkg="criu libcgroup runc containerd docker-cli docker kubernetes-kubelet kubernetes-client kubernetes-node kubernetes-kubeadm kubernetes-master containernetworking-plugins"
declare -A images=(
    ["flannel"]="FLANNEL_VERSION"
    ["flannel-cni-plugin"]="FLANNEL_CNI_PLUGIN_VERSION"
    ["kube-proxy"]="KUBE_PROXY_VERSION"
    ["kube-controller-manager"]="KUBE_CONTROLLER_MANAGER_VERSION"
    ["kube-apiserver"]="KUBE_APISERVER_VERSION"
    ["kube-scheduler"]="KUBE_SCHEDULER_VERSION"
    ["etcd"]="ETCD_VERSION"
    ["coredns"]="COREDNS_VERSION"
    ["pause"]="PAUSE_VERSION"
)
