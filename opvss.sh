#!/bin/bash
#opvss (Wegare)
udp2="$(cat /root/akun/opvss.txt | grep -i udp | cut -d= -f2)" 
host2="$(cat /root/akun/opvss.txt | grep -i host | cut -d= -f2 | head -n1)" 
port2="$(cat /root/akun/opvss.txt | grep -i port | cut -d= -f2)" 
bug2="$(cat /root/akun/opvss.txt | grep -i bug | cut -d= -f2)" 
pass2="$(cat /root/akun/opvss.txt | grep -i pass | cut -d= -f2)" 
enc2="$(cat /root/akun/opvss.txt | grep -i enc | cut -d= -f2)" 
uid2="$(cat /root/akun/opvss.txt | grep -i uid | cut -d: -f2)" 
publickey2="$(cat /root/akun/opvss.txt | grep -i publickey | cut -d: -f2)" 
plugin2="$(cat /root/akun/opvss.txt | grep -i plugin | cut -d= -f2)" 
obfs2="$(cat /root/akun/opvss.txt | grep -i obfs | cut -d= -f2 | tail -n1)" 
user4="$(cat /root/akun/pass-opvss.txt | awk 'NR==1')" 
pass4="$(cat /root/akun/pass-opvss.txt | awk 'NR==2')" 
openvpn2="$(cat /root/akun/opvss.txt | grep -i direkopvpn | cut -d= -f2)" 
clear
echo "Inject openvpn shadowsocks obfs/cloak by wegare"
echo "1. Sett Profile"
echo "2. Start Inject"
echo "3. Stop Inject"
echo "4. Enable auto booting & auto rekonek"
echo "5. Disable auto booting & auto rekonek"
echo "e. exit"
read -p "(default tools: 2) : " tools
[ -z "${tools}" ] && tools="2"
if [ "$tools" = "1" ]; then
echo "SETT PROFILE SHADOWSOCKS" 
echo "Masukkan host/ip" 
read -p "default host/ip: $host2 : " host
[ -z "${host}" ] && host="$host2"

echo "Masukkan port" 
read -p "default port: $port2 : " port
[ -z "${port}" ] && port="$port2"

echo "Masukkan pass" 
read -p "default pass: $pass2 : " pass
[ -z "${pass}" ] && pass="$pass2"

echo "Masukkan bug" 
read -p "default bug: $bug2 : " bug
[ -z "${bug}" ] && bug="$bug2"

echo "Masukkan encryption method" 
read -p "default encryption method: $enc2 : " enc
[ -z "${enc}" ] && enc="$enc2"

read -p "ingin menggunakan plugin y/n " pilih2
if [ "$pilih2" = "y" ]; then
echo "Silahkan pilih plugin obfs/cloak" 
read -p "default plugin: $plugin2 : " plugin
[ -z "${plugin}" ] && plugin="$plugin2"
if [ "$plugin" = "obfs" ]; then
echo "Silahkan pilih method obfs http/tls" 
read -p "default plugin: $obfs2 : " obfs
[ -z "${obfs}" ] && obfs="$obfs2"
metode="obfs-local"
plugin_opts="obfs=$obfs;obfs-host=$bug"
elif [ "$plugin" = "cloak" ]; then
echo "Masukkan UID" 
read -p "default UID: $uid2 : " uid
[ -z "${uid}" ] && uid="$uid2"
echo "Masukkan publickey" 
read -p "default publickey: $publickey2 : " publickey
[ -z "${publickey}" ] && publickey="$publickey2"
metode="ck-client"
plugin_opts="UID=$uid;PublicKey=$publickey;ServerName=$bug;BrowserSig=chrome;NumConn=100;ProxyMethod=shadowsocks;EncryptionMethod=plain;StreamTimeout=300"
else 
echo -e "$plugin: invalid selection."
exit
fi

cat <<EOF> /root/akun/opvss.json
{
  "server" : "$host",
  "server_port" : "$port",
  "method" : "$enc",
  "password" : "$pass",
  "plugin" : "$metode",
  "plugin_opts" : "$plugin_opts",
  "local_port" : 1080,
  "local_address" : "127.0.0.1",
  "timeout" : 60
}
EOF
else
cat <<EOF> /root/akun/opvss.json
{
  "server" : "$host",
  "server_port" : "$port",
  "method" : "$enc",
  "password" : "$pass",
  "local_port" : 1080,
  "local_address" : "127.0.0.1",
  "timeout" : 60
}
EOF
fi
echo "SETT PROFILE OPENVPN" 
echo "Masukkan user" 
read -p "default user: $user4 : " user3
[ -z "${user3}" ] && user3="$user4"

echo "Masukkan pass" 
read -p "default pass: $pass4 : " pass3
[ -z "${pass3}" ] && pass3="$pass4"

echo ""
echo "edit config ovpn" 
echo "tambahkan /root/akun/pass-opvss.txt di auth-user-pass" 
echo "contoh : auth-user-pass /root/akun/pass-opvss.txt" 
echo "tambahkan dibawah auth-user-pass /root/akun/pass-opvss.txt"
echo "socks-proxy 127.0.0.1 1080"
echo "route $host 255.255.255.255 net_gateway"
echo "save lalu masukkan config kedalam direktori root openwrt"
echo ""
echo "Masukkan nama config ovpn" 
echo "contoh wegare.ovpn" 
read -p "default nama config ovpn: $openvpn2 : " openvpn
[ -z "${openvpn}" ] && openvpn="$openvpn2"

echo "host=$host
port=$port
enc=$enc
pass=$pass
bug=$bug
publickey:$publickey
uid:$uid
plugin=$plugin
obfs=$obfs
udp=$udp
direkopvpn=$openvpn" > /root/akun/opvss.txt
echo "$user3
$pass3" > /root/akun/pass-opvss.txt
echo "Sett Profile Sukses"
sleep 2
clear
/usr/bin/opvss
elif [ "${tools}" = "2" ]; then
opvpn3="$(cat /root/akun/opvss.txt | grep -i direkopvpn | cut -d= -f2 | head -n1)" 
opvpn=$(find /root -name $opvpn3)
ss-local -c /root/akun/opvss.json &
sleep 3
openvpn $opvpn &
fping -l google.com > /dev/null 2>&1 &
elif [ "${tools}" = "3" ]; then
killall -q openvpn ss-local dnsmasq fping
/etc/init.d/dnsmasq start > /dev/null
echo "Stop Suksess"
sleep 2
clear
/usr/bin/opvss
elif [ "${tools}" = "4" ]; then
cat <<EOF>> /etc/crontabs/root

# BEGIN AUTOREKONEKOPVSS
*/1 * * * *  autorekonek-opvss
# END AUTOREKONEKOPVSS
EOF
sed -i '/^$/d' /etc/crontabs/root 2>/dev/null
/etc/init.d/cron restart
echo "Enable Suksess"
sleep 2
clear
/usr/bin/opvss
elif [ "${tools}" = "5" ]; then
sed -i "/^# BEGIN AUTOREKONEKOPVSS/,/^# END AUTOREKONEKOPVSS/d" /etc/crontabs/root > /dev/null
/etc/init.d/cron restart
echo "Disable Suksess"
sleep 2
clear
/usr/bin/opvss
elif [ "${tools}" = "e" ]; then
clear
exit
else 
echo -e "$tools: invalid selection."
exit
fi