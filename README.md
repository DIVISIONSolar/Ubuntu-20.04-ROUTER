# Ubuntu-20.04-ROUTER

`sudo su` OR `sudo -i`

`nano /etc/netplan/<name>.yaml`

Fill your `.yaml` file with this:

```
network:
    version: 2
    renderer: networkd
    ethernets:
### WAN INTERFACE <interface ID (Ex. eno1)> DHCP ###
     eno1:
      dhcp4: yes
     
### LAN INTERFACE <interface ID (Ex. eno2)> STATIC ###
     eno2:
      addresses:
       - 10.10.10.1/24
```
Run:

```netplan apply```

Then run:

```ip addr``` to make sure the changes applied

```ping 8.8.8.8``` to make sure you have a connection

```nano /etc/sysctl.conf``` then add: ```net.ipv4.ip_forward=1```

```sysctl -p```

Then run: ```apt -y update && apt -y upgrade```

```apt -y install iptables-persistent```

```iptables -t nat -A POSTROUTING -j MASQUERADE```

```iptables-save > /etc/iptables/rules.v4```

################################################

Changing the DNS:

```echo nameserver 8.8.8.8 | sudo tee /etc/resolv.conf```

```sudo apt install resolvconf```

```sudo systemctl start resolvconf.service & sudo systemctl enable resolvconf.service```

```sudo nano /etc/resolvconf/resolv.conf.d/head``` and fill it with:

```nameserver 8.8.8.8``` 

```sudo systemctl restart resolvconf.service```

################################################

Setting up the DHCP server:

```apt-get install isc-dhcp-server```

```systemctl start isc-dhcp-server.service && systemctl enable isc-dhcp-server.service```

```nano /etc/dhcp/dhcpd.conf``` and fill it with:

```
default-lease-time 600;
max-lease-time 7200;
authoritive;

subnet 10.10.10.0 netmask 255.255.255.0 {
 range 10.10.10.10 10.10.10.200;
 option routers 10.10.10.1;
 option domain-name-servers 8.8.8.8, 8.8.4.4;
}
```
add your interface to: ```/etc/default/isc-dhcp-server```

```nano /etc/default/isc-dhcp-server```

```INTERFACESv4="eno1"```

```systemctl restart isc-dhcp-server.service```

then:

```systemctl status isc-dhcp-server.service```

# To install ntopng run: ```bash <(curl https://raw.githubusercontent.com/DIVISIONSolar/Ubuntu-20.04-ROUTER/main/scripts/ntopng.sh)```
