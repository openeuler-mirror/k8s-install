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

#rm -f *.tar

# pull docker images.
for image_name in "${!images[@]}"; do
    # 获取镜像版本
    image_version="${images[$image_name]}"
    version="${!image_version}"
    if [[ $image_name != flannel* ]];then
        full_image_name="${IMAGE_REPO}/${image_name}:${version}"
    else
        full_image_name="${FLN_IMAGE_REPO}/${image_name}:${version}"
    fi
    # 执行containerd images pull & containerd export 命令
    echo "Pulling image"
    ctr images pull "$full_image_name"

    echo "save containerd images to tar"
    ctr images export  ${image_name}-${KUBERNETES_VERSION}.tar "$full_image_name"
done

echo "All images have been pulled and saved."
