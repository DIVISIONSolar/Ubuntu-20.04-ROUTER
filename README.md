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
```netplan apply```
