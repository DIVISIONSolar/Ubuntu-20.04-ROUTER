# Ubuntu-20.04-ROUTER

`sudo su` OR `sudo -i`

`nano /etc/netplan/<name>.yaml`

Fill your `.yaml` file with this:

```network:
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

