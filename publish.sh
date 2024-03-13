#! /bin/bash
while getopts "b:" opt; do
  case $opt in
    b) build_version=$OPTARG ;;
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done

if [ -z "$build_version" ]; then
    echo "Build version (-b) not specified. Exiting."
    exit 1
fi

echo "============ Pull rpm packages ============"
cd rpms/
./init.sh 
cd -

echo "============ Pull x86_64 docker images, and save to tar ============"
cd tar-x86_64/
./init.sh 
cd -

echo "============ Pull aarch64 docker images, and save to tar ============"
cd tar-aarch64/ 
./init.sh
cd -

dist=("ctl2" "ctl3")
arch=("x86_64" "aarch64")

# Generate offline tar balls and upload onto repo server
echo "============ Generate offline tar balls and upload onto repo server ============"
rm -rf /tmp/k8s-install-offline
mkdir -p /tmp/k8s-install-offline/rpms
cp -r config k8s-install-offline README.md /tmp/k8s-install-offline
chmod 400 rsync.password
for a in ${arch[@]};do
    mkdir -p /tmp/k8s-install-offline/tar-$a
    cp  tar-$a/*.tar /tmp/k8s-install-offline/tar-$a/
    for d in ${dist[@]};do
        rm -f /tmp/k8s-install-offline/rpms/*
        cp rpms/*.$d.$a.rpm rpms/*.$d.noarch.rpm /tmp/k8s-install-offline/rpms/ >/dev/null 2>&1
        cd /tmp
        tar zcf k8sinstall-$d-$a.tgz k8s-install-offline/
        cd -
        rsync --delete --partial -avzuP /tmp/k8sinstall-$d-$a.tgz ctyunos@124.236.120.248::ctyunos/ctyunos_testing/k8sinstall-$d-$a.tgz --password-file=rsync.password
        echo "/tmp/k8sinstall-$d-$a.tgz is published!"
        # rm -rf /tmp/k8sinstall-*.tgz
    done
    rm -rf /tmp/k8s-install-offline/tar-$a
done
rm -rf /tmp/k8s-install-offline

# Retar source code and cherrypick to build branch
echo "============ Retar source code and cherrypick to build branch ============"
git status | grep "nothing to commit"
[[ $? == 0 ]] || (echo "Some git changes still not committed. exit.." && exit)
rm -rf /tmp/k8s-install
mkdir -p /tmp/k8s-install
cp -r config k8s-install /tmp/k8s-install
cd /tmp
tar zcf k8s-install.tgz k8s-install/
cd -
git checkout obsbuild
mv /tmp/k8s-install.tgz .
rpmbuild -bb --define "_sourcedir $(pwd)" *.spec  # Just a test
git add .
git commit -m "commit changes into obsbuild branch."
git push
