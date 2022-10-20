sudo dnsmasq -kd -p 0 -C /dev/null -u nobody --enable-tftp --tftp-root=$(pwd)/build
