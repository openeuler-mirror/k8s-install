#! /bin/bash
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

source config/jianguoyun.config
while getopts "b:d:a:" opt; do
  case $opt in
    b)  case "$OPTARG" in
            "120"|"125"|"129")
            build_version=$OPTARG
            version_function="set_version_${build_version}"
            ;;
        *)
            echo "unsupport build_version $OPTARG.."&& exit 1
            ;;
        esac
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
    \?) echo "Invalid option: -$opt" >&2; exit 1 ;;
  esac
done

if [ -z "$build_version" ]; then
    echo "Build version (-b) not specified. Exiting."
    exit 1
fi
if [ -z "$dist" ]; then
    echo "Dist (-d) not specified. Exiting."
    exit 1
fi

echo "============ Pull rpm packages ============"
echo "./init.sh -b ${build_version}  -d ${dist} -a ${arch}"
cd rpms/
./init.sh  -b ${build_version} -d ${dist} -a ${arch}
cd -

if [ $arch == "x86_64" ]; then
    echo "============ Pull x86_64 docker images, and save to tar ============"
    cd tar-x86_64/
    ./init.sh $build_version
    cd -

else
    echo "============ Pull aarch64 docker images, and save to tar ============"
    cd tar-aarch64/ 
    ./init.sh $build_version
    cd -
fi

# Generate offline tar balls and upload onto repo server
echo "============ Generate offline tar balls and upload onto repo server ============"
rm -rf /tmp/k8s-install-offline
mkdir -p /tmp/k8s-install-offline/rpms
cp -r config k8s-install-offline README.md variable.sh /tmp/k8s-install-offline
mkdir -p /tmp/k8s-install-offline/tar-$arch
cp  tar-$arch/*.tar /tmp/k8s-install-offline/tar-$arch/
rm -f /tmp/k8s-install-offline/rpms/*
if [ $dist == oe* ]; then
    cp rpms/*.$arch.rpm rpms/*.noarch.rpm /tmp/k8s-install-offline/rpms/ >/dev/null 2>&1
else
    cp rpms/*.$dist.$arch.rpm rpms/*.$dist.noarch.rpm /tmp/k8s-install-offline/rpms/ >/dev/null 2>&1
fi
cd /tmp
tar zcf $arch.tgz k8s-install-offline/
echo "tgz is publishing..."
curl --http1.1 -u $username:$password -T $arch.tgz "https://dav.jianguoyun.com/dav/k8s-install-rpms/${dist}/${build_version}/${arch}.tgz"
cd -
echo "/tmp/k8sinstall-$d-${build_version}-$arch.tgz is published!"
rm -rf /tmp/$a.tgz
rm -rf /tmp/k8s-install-offline/tar-$arch
rm -rf /tmp/k8s-install-offline

# Retar source code and cherrypick to build branch
echo "============ Retar source code and cherrypick to build branch ============"
git status | grep "nothing to commit"
[[ $? == 0 ]] || (echo "Some git changes still not committed. exit.." && exit)
rm -rf /tmp/k8s-install
mkdir -p /tmp/k8s-install
cp -r config k8s-install variable.sh /tmp/k8s-install 
cd /tmp
tar zcf k8s-install.tgz k8s-install/
cd -
git checkout obsbuild
mv /tmp/k8s-install.tgz .
rpmbuild -bb --define "_sourcedir $(pwd)" *.spec  # Just a test
git add .
git commit -m "commit changes into obsbuild branch."
git push
