#!/bin/bash

IP=''
PORT='1194'

path_ca= 'pki/ca.crt'
path_ta= 'pki/ta.crt'



cd /etc/openvpn/easy-rsa/
for user_name in $*
do
	./easyrsa build-client-full ${user_name} nopass
	mkdir /root/${user_name}
	cp ${path_ca} /root/${user_name}/ca.crt
	cp pki/issued/${user_name}.crt /root/${user_name}/client.crt
	cp pki/private/${user_name}.key /root/${user_name}/client.key
	cp ${path_ta} /root/${user_name}/ta.key
	ca=$(cat /root/${user_name}/ca.crt)
	cert=$(cat /root/${user_name}/client.crt)
	key=$(cat /root/${user_name}/client.key)
	tls=$(cat /root/${user_name}/ta.key)
	touch /root/${user_name}/client.ovpn
	echo "# Secure OpenVPN Client Config

#viscosity dns full
#viscosity usepeerdns true
#viscosity dhcp true
tls-client
pull
client
dev tun
proto udp
# modifier l'adresse en fonction de votre adresse IP public/port
remote $IP $PORT
################################
# choix du mode split ou passerelle (mode par defaut: passerelle)
redirect-gateway def1
# modifier l'adresse et le masque en fonction de votre reseau
#route 192.168.1.0 255.255.255.0
################################
nobind
persist-key
persist-tun
comp-lzo
verb 3
<ca>
$ca
</ca>
#ca ca.crt
<cert>
$cert
</cert>
#cert client.crt
<key>
$key
</key>
#key client.key
<tls-auth>
$tls
</tls-auth>
#tls-auth ta.key 1
remote-cert-tls server
#ns-cert-type server
key-direction 1
cipher AES-256-CBC
tls-version-min 1.2
auth SHA512
auth-nocache
tls-cipher TLS-DHE-RSA-WITH-AES-256-GCM-SHA384:TLS-DHE-RSA-WITH-AES-256-CBC-SHA256:TLS-DHE-RSA-WITH-AES-128-GCM-SHA256:TLS-DHE-RSA-WITH-AES-128-CBC-SHA256
" > /root/${user_name}/client.ovpn
done

./easyrsa gen-crl
systemctl restart openvpn@server
