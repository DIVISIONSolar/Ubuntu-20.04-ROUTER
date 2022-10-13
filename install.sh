echo "What's the WAN Interface you wish to configure for your network?"
read interface_wan

echo "What's the LAN Interface you wish to configure for your network?"
read interface_lan

echo " 
network:
    version: 2
    renderer: networkd
    ethernets:
### WAN INTERFACE $interface_wan DHCP ###
     $interface_wan:
      dhcp4: yes
     
### LAN INTERFACE $interface_lan STATIC ###
     $interface_lan:
      addresses:
       - 10.10.10.1/24

" > /etc/netplan/main.yaml

netplan apply

echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf

sysctl -p

apt -y update
apt -y upgrade

apt -y install iptables-persistent

iptables -t nat -A POSTROUTING -j MASQUERADE
iptables-save > /etc/iptables/rules.v4
apt -y install resolvconf

sudo systemctl start resolvconf.service
sudo systemctl enable resolvconf.service

echo "
nameserver 8.8.8.8
nameserver 8.8.4.4
" > /etc/resolvconf/resolv.conf.d/head

systemctl restart resolvconf.service

apt-get -y install isc-dhcp-server

systemctl start isc-dhcp-server.service
systemctl enable isc-dhcp-server.service

echo "
default-lease-time 600;
max-lease-time 7200;
authoritive;

subnet 10.10.10.0 netmask 255.255.255.0 {
 range 10.10.10.10 10.10.10.200;
 option routers 10.10.10.1;
 option domain-name-servers 8.8.8.8, 8.8.4.4;
} " > /etc/dhcp/dhcpd.conf

rm /etc/default/isc-dhcp-server

echo "What's the WAN Interface you wish to configure for your DHCP network?"
read interface_wan

echo "What's the LAN Interface you wish to configure for your DHCP network?"
read interface_lan

echo "
INTERFACESv4=\"$interface_wan $interface_lan\"
INTERFACESv6="""" 
" > /etc/default/isc-dhcp-server

systemctl restart isc-dhcp-server.service

echo "Do you wish to restart the server?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) reboot;;;
        No ) exit;;
    esac
done
