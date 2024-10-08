#!/bin/bash
source ../variable.sh 
usetemprepo=0

help() {
    echo "Usage:"
    echo "Setup: $0 <-d DIST> <-b BASELINE> <-a ARCH>"
    echo "Description:"
    echo "-b BASELINE, e.g. 120 or 125 or 129"
    echo "-d DIST, e.g. ctl2 or ctl3 or ctl4 or oe2309 or oe2403"
    echo "-a ARCH, e.g. x86_64 or aarch64"
    exit -1
}
[[ $# == 0 ]] && help && exit

while getopts 'd:b:a:' OPT; do
    case $OPT in
        b)  if [ "$OPTARG" == "120" ];then
                rpmlist_cloud=("libcgroup" "runc" "containerd" "docker" "containernetworking-plugins" "kubernetes-kubelet" "kubernetes-client" "kubernetes-node" "kubernetes-kubeadm" "kubernetes-master")
                rpmlist="protobuf zlib-devel vim-filesystem vim-common libnetfilter_queue libnetfilter_cttimeout libnetfilter_cthelper gpm-libs vim-enhanced emacs-filesystem protobuf-devel protobuf-c conntrack-tools-help conntrack-tools socat criu"
            elif [[ "$OPTARG" == "125" || "$OPTARG" == "129" ]]; then
                 rpmlist_cloud=("libcgroup" "runc" "containerd" "moby-client" "moby" "moby-engine" "containernetworking-plugins" "kubernetes-kubelet" "kubernetes-client" "kubernetes-node" "kubernetes-kubeadm" "kubernetes-master")
		 rpmlist="conntrack-tools-help conntrack-tools socat cri-tools container-selinux"
            else
                echo "Version function $version_function not found. Exiting." && exit
            fi
            version_function="set_version_${OPTARG}"
	    build_version=$OPTARG
            $version_function
            ;;
        d)  case "$OPTARG" in
                "ctl2"|"ctl3"|"ctl4"|"oe2403"|"oe2309")
                    dist=$OPTARG
                    ;;
                *)
                    echo "unsupported dist type $OPTARG..." && exit 1
                    ;;
            esac
            ;;
	a) case "$OPTARG" in
		"x86_64"|"aarch64")
		    arch=$OPTARG
		    ;;
	        *)
		    echo "unsupported arch type $OPTARG..." && exit 1
		    ;;
	   esac
	   ;;
    esac
done    

if [[ $dist == oe* ]]; then
    if [[ $build_version == "125" ]]; then
        cp ../config/openEuler2309.repo  /etc/yum.repos.d/ --update
        #添加129源（使用特定containerd版本）
        cp ../config/openEuler2403.repo /etc/yum.repos.d/ --update
        install_para="--disablerepo=* --enablerepo=OS-2309 --enablerepo=everything-2309 --enablerepo=EPOL-2309"
        ctrd_install_para="--disablerepo=* --enablerepo=OS-2403 --enablerepo=everything-2403  --enablerepo=update-2403"
        yum_repo="openEuler2*"
        usetemprepo=1
	rpmlist_cloud=("libcgroup" "docker-runc" "containerd" "moby-client" "moby" "moby-engine" "containernetworking-plugins" "kubernetes-kubelet" "kubernetes-client" "kubernetes-node" "kubernetes-kubeadm" "kubernetes-master" "tar")
    elif [[ $build_version == "129" ]]; then
        cp ../config/openEuler2403.repo /etc/yum.repos.d/ --update
        install_para="--disablerepo=* --enablerepo=OS-2403 --enablerepo=everything-2403 --enablerepo=EPOL-2403 --enablerepo=update-2403"
        yum_repo="openEuler2403.repo"
        ctrd_install_para="--disablerepo=* --enablerepo=OS-2403 --enablerepo=everything-2403  --enablerepo=update-2403"
        usetemprepo=1
    fi
fi



#rm -f *.rpm
sudo yum makecache
#yum download --repo=$dist --repo=${dist}-update --forcearch=$arch $rpmlist 
yum download  --forcearch=$arch $rpmlist
for pkg in ${rpmlist_cloud[@]}; do
    version_var=$(echo "${pkg^^}" | tr '-' '_')_VERSION  # Convert package name to uppercase and append _VERSION
    version_var=${!version_var}                 # Dereference to get the version
    if [[ ! -z "$version_var" && $pkg != "containerd" ]]; then
	    if [[ $dist == oe*  ]];then
       		 #yum download --repo=$dist --repo=${dist}-update --forcearch=$arch "${pkg}-${version_var}" 
		yum download ${pkg}.${arch}  $install_para
	    else
		yum download  --forcearch=$arch ${pkg}-${version_var}.${dist} $install_para
	    fi
    elif [ $pkg == "containerd" ];then
	    if [[ $dist == oe*  ]];then
		yum download ${pkg}.${arch} $ctrd_install_para
	    else
		yum download  --forcearch=$arch ${pkg}-${version_var}.${dist} $ctrd_install_para
	    fi
    else
        echo "No version specified for $pkg, skipping..."
    fi
done

if [ $usetemprepo == 1 ]; then
    rm -f /etc/yum.repos.d/${yum_repo}
fi
