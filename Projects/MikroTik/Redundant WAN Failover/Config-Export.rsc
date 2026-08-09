
/ip address
add address=192.168.11.143/24 comment="Static IP for WAN-2" interface=ether2 network=192.168.11.0

/ip dhcp-client
add add-default-route=no comment="From Fiber Modem DHCP Server" disabled=no interface=ether1 use-peer-dns=no use-peer-ntp=no

/ip route
add check-gateway=ping comment="WAN-1 - Fiber Modem" distance=1 gateway=1.0.0.2 target-scope=30
add check-gateway=ping comment="WAN-2 - Wireless" distance=2 gateway=1.0.0.3 target-scope=30
add comment="Probe WAN-1" distance=1 dst-address=1.0.0.2/32 gateway=192.168.88.1
add comment="Probe WAN-2" distance=1 dst-address=1.0.0.3/32 gateway=192.168.11.2
