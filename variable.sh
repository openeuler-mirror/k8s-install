set_version_120(){
    # images version
    export FLANNEL_VERSION="v0.25.1"
    export FLANNEL_CNI_PLUGIN_VERSION="v1.4.1-flannel1"
    export KUBE_PROXY_VERSION="v1.20.2"
    export KUBE_CONTROLLER_MANAGER_VERSION="v1.20.2"
    export KUBE_APISERVER_VERSION="v1.20.2"
    export KUBE_SCHEDULER_VERSION="v1.20.2"
    export ETCD_VERSION="3.4.13-0"
    export COREDNS_VERSION="1.7.0"
    export PAUSE_VERSION="3.2"

    # pkg version
    export CRIU_VERSION="3.15-2"
    export CRI_TOOLS_VERSION="1.22.0-5"
    export RUNC_VERSION="1.1.12-1"
    export CONTAINERD_VERSION="1.5.6-1"
    export DOCKER_CLI_VERSION="20.10.12-2"
    export DOCKER_VERSION="20.10.12-2"
    export DOCKER_ENGINE_VERSION="20.10.12-2"
    export KUBERNETES_KUBELET_VERSION="1.20.2-16"
    export KUBERNETES_CLIENT_VERSION="1.20.2-16"
    export KUBERNETES_NODE_VERSION="1.20.2-16"
    export KUBERNETES_KUBEADM_VERSION="1.20.2-16"
    export KUBERNETES_MASTER_VERSION="1.20.2-16"
    #export CONTAINERNETWORKING_PLUGINS_VERSION="0.8.6-4.git40b4237"
    export KUBERNETES_VERSION="1.20.2"
}

set_version_125(){
    # images version
    export FLANNEL_VERSION="v0.25.1"
    export FLANNEL_CNI_PLUGIN_VERSION="v1.4.1-flannel1"
    export KUBE_PROXY_VERSION="v1.25.3"
    export KUBE_CONTROLLER_MANAGER_VERSION="v1.25.3"
    export KUBE_APISERVER_VERSION="v1.25.3"
    export KUBE_SCHEDULER_VERSION="v1.25.3"
    export ETCD_VERSION="3.5.4-0"
    export COREDNS_VERSION="v1.9.3"
    export PAUSE_VERSION="3.8"

    # pkg version
    #export CRIU_VERSION="3.16.1-6"
    export CRI_TOOLS_VERSION="1.24.2-1"
    export RUNC_VERSION="1.1.8-6"
    export CONTAINERD_VERSION="1.6.22-15"
    #export DOCKER_CLI_VERSION=""
    #export DOCKER_VERSION=""
    export MOBY_VERSION="20.10.24-7"
    export MOBY_CLIENT_VERSION="20.10.24-7"
    export MOBY_ENGINE_VERSION="20.10.24-7"
    export KUBERNETES_KUBELET_VERSION="1.25.3-1"
    export KUBERNETES_CLIENT_VERSION="1.25.3-1"
    export KUBERNETES_NODE_VERSION="1.25.3-1"
    export KUBERNETES_KUBEADM_VERSION="1.25.3-1"
    export KUBERNETES_MASTER_VERSION="1.25.3-1"
    #export CONTAINERNETWORKING_PLUGINS_VERSION="1.2.0-1"
    export KUBERNETES_VERSION="1.25.3"
}

set_version_129(){
    # images version
    export FLANNEL_VERSION="v0.25.1"
    export FLANNEL_CNI_PLUGIN_VERSION="v1.4.1-flannel1"
    export KUBE_PROXY_VERSION="v1.29.1"
    export KUBE_CONTROLLER_MANAGER_VERSION="v1.29.1"
    export KUBE_APISERVER_VERSION="v1.29.1"
    export KUBE_SCHEDULER_VERSION="v1.29.1"
    export ETCD_VERSION="3.5.10-0"
    export COREDNS_VERSION="v1.11.1"
    export PAUSE_VERSION="3.9"

    # pkg version
    #export CRIU_VERSION="3.19-2"
    export CRI_TOOLS_VERSION="1.29.0-3"
    export RUNC_VERSION="1.1.8-21"
    export CONTAINERD_VERSION="1.6.22-15"
    export DOCKER_VERSION="25.0.3-10"
    export DOCKER_CLIENT_VERSION="25.0.3-10"
    export DOCKER_ENGINE_VERSION="25.0.3-10"
    export KUBERNETES_KUBELET_VERSION="1.29.1-7"
    export KUBERNETES_CLIENT_VERSION="1.29.1-7"
    export KUBERNETES_NODE_VERSION="1.29.1-7"
    export KUBERNETES_KUBEADM_VERSION="1.29.1-7"
    export KUBERNETES_MASTER_VERSION="1.29.1-7"
    #export CONTAINERNETWORKING_PLUGINS_VERSION="1.2.0-3"
    export KUBERNETES_VERSION="1.29.1"
}


export IMAGE_REPO="registry.aliyuncs.com/google_containers"
export FLN_IMAGE_REPO="registry.cn-hangzhou.aliyuncs.com/k8s-install-flannel-`arch`"
export etcd_insert_content="- --cipher-suites=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA"
export kube_apiserver_insert_content="- --tls-cipher-suites=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA"
export kube_controller_insert_content="- --tls-cipher-suites=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA
"
export kube_scheduler_insert_content="- --tls-cipher-suites=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA"
export kubelet_insert_content="tlsCipherSuites: [TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256,TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA,TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA,TLS_RSA_WITH_AES_128_GCM_SHA256,TLS_RSA_WITH_AES_256_GCM_SHA384,TLS_RSA_WITH_AES_128_CBC_SHA,TLS_RSA_WITH_AES_256_CBC_SHA]"

#export offline_rpmlist="containernetworking-plugins protobuf zlib-devel vim-filesystem vim-common libnetfilter_queue libnetfilter_cttimeout libnetfilter_cthelper gpm-libs vim-enhanced emacs-filesystem protobuf-devel protobuf-c conntrack-tools-help conntrack-tools cri-tools socat libcgroup runc containerd docker-cli docker kubernetes-client kubernetes-kubeadm kubernetes-master kubernetes-kubelet kubernetes-node"
export online_install_pkg="cri-tools libcgroup runc containerd docker-cli docker kubernetes-kubelet kubernetes-client kubernetes-node kubernetes-kubeadm kubernetes-master containernetworking-plugins"
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
