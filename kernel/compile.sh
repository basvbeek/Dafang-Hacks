apt update && apt install -y bc u-boot-tools
#make clean
make uImage -j8
make modules
make headers_install