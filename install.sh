#!/bin/bash
#opvss (Wegare)
opkg update
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/opvss/main/opvss.sh" -O /usr/bin/opvss
wget --no-check-certificate "https://raw.githubusercontent.com/wegare123/opvss/main/autorekonek-opvss.sh" -O /usr/bin/autorekonek-opvss
wget --no-check-certificate "https://github.com/wegare123/sst/blob/main/simple-obfs_0.0.5-5_aarch64_cortex-a53.ipk?raw=true" -O ~/simple-obfs.ipk
wget --no-check-certificate "https://github.com/wegare123/sst/blob/main/ck-client?raw=true" -O /usr/bin/ck-client
cek2=$(ls /usr/bin/ | grep ss-local)
if [ $cek2 = "ss-local" ]; then
echo > /dev/null
else
opkg install shadowsocks-libev-ss-local
fi
opkg install *.ipk && opkg install lsof openvpn-openssl fping
chmod +x /usr/bin/ck-client
chmod +x /usr/bin/opvss
chmod +x /usr/bin/autorekonek-opvss
rm -r ~/install.sh
rm -r ~/*.ipk
mkdir -p ~/akun/
touch ~/akun/opvss.txt
touch ~/akun/pass-opvss.txt
sleep 2
echo "install selesai"
echo "untuk memulai tools silahkan jalankan perintah 'opvss'"

				