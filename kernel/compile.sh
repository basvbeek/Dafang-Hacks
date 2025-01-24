ROOTPATH=$(git rev-parse --show-toplevel)
export INSTALLDIR=${ROOTPATH}/_install
export INSTALL_MOD_PATH=${INSTALLDIR}/lib/modules/

apt update && apt install -y bc u-boot-tools
#make clean
make uImage -j8
make modules
make headers_install