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

rm -f *.tar

# pull docker images.
for image_name in "${!images[@]}"; do
    # 获取镜像版本
    image_version="${images[$image_name]}"
    version="${!image_version}"
    full_image_name="${IMAGE_REPO}/base-x86_64/${image_name}:${version}"
    # 执行docker pull & docker save 命令
    echo "Pulling image"
    docker pull "$full_image_name"

    echo "save docker images to tar"
    docker save "$full_image_name" -o ${image_name}.tar
done

echo "All images have been pulled and saved."

