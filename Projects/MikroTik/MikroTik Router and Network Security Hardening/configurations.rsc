# aug/14/2026 17:17:09 by RouterOS 6.49.20
# software id = 
#
#
#
/interface ethernet
set [ find default-name=ether1 ] comment=WAN-1 disable-running-check=no
/ip pool
add name=VPN-Pool ranges=192.168.200.2-192.168.200.254
/ppp profile
set *0 change-tcp-mss=default
add change-tcp-mss=yes dns-server=192.168.88.10 local-address=192.168.200.1 \
    name="L2TP Server" only-one=yes remote-address=VPN-Pool use-compression=\
    no use-encryption=yes
/system logging action
set 0 memory-lines=50
/interface l2tp-server server
set authentication=mschap2 default-profile="L2TP Server" enabled=yes \
    ipsec-secret=1234 use-ipsec=required
/ip address
add address=192.168.88.10/24 comment=WAN-1 interface=ether1 network=\
    192.168.88.0
/ip dns
set allow-remote-requests=yes servers=1.1.1.2,1.0.0.2 use-doh-server=\
    https://security.cloudflare-dns.com/dns-query
/ip firewall address-list
add address=5.237.2.1 list="White List"
add address=192.168.88.3 list=Scanner
/ip firewall filter
add action=accept chain=input comment="Accept Es. & Rel." connection-state=\
    established,related in-interface=ether1
add action=drop chain=input comment="Drop Invalid" connection-state=invalid \
    in-interface=ether1
add action=accept chain=input comment="Allowed IPs" in-interface=ether1 \
    src-address-list="White List"
add action=accept chain=input comment=WinBox dst-port=8200 in-interface=\
    ether1 protocol=tcp
add action=add-src-to-address-list address-list=Scanner address-list-timeout=\
    none-static chain=input comment="TCP Scanner" in-interface=ether1 log=yes \
    log-prefix=Scanner- protocol=tcp psd=21,3s,3,1
add action=add-src-to-address-list address-list=Scanner address-list-timeout=\
    none-static chain=input comment="UDP Scanner" in-interface=ether1 \
    protocol=udp psd=21,3s,3,1
add action=accept chain=input comment="L2TP 1" dst-port=500,4500,1701 \
    in-interface=ether1 log=yes protocol=udp
add action=accept chain=input comment="L2TP 2" in-interface=ether1 protocol=\
    ipsec-esp
add action=drop chain=input comment="Drop All" in-interface=ether1 log=yes \
    log-prefix=Dropped-
/ip firewall nat
add action=redirect chain=dstnat dst-port=53 protocol=udp src-address=\
    192.168.0.0/16 to-ports=53
add action=redirect chain=dstnat dst-port=53 protocol=tcp src-address=\
    192.168.0.0/16 to-ports=53
add action=masquerade chain=srcnat comment="Masquerade VPN" src-address=\
    192.168.200.0/24
/ip firewall raw
add action=drop chain=prerouting comment="Drop Scanners" in-interface=ether1 \
    src-address-list=Scanner
add action=drop chain=prerouting comment="RDP & SMB" dst-port=\
    3389,135,139,445 in-interface=ether1 protocol=tcp src-address=\
    !192.168.0.0/16
add action=drop chain=prerouting comment="RDP & SMB" dst-port=\
    3389,135,137,138 in-interface=ether1 protocol=udp src-address=\
    !192.168.0.0/16
add action=drop chain=output comment="Test DoH" disabled=yes dst-port=53 \
    out-interface=ether1 protocol=udp
add action=drop chain=output comment="Test DoH" disabled=yes dst-port=53 \
    out-interface=ether1 protocol=tcp
/ip firewall service-port
set ftp disabled=yes
set tftp disabled=yes
set irc disabled=yes
set h323 disabled=yes
set pptp disabled=yes
set udplite disabled=yes
set dccp disabled=yes
set sctp disabled=yes
/ip route
add comment=WAN-1 distance=1 gateway=192.168.88.1 target-scope=30
/ip service
set telnet disabled=yes
set ftp disabled=yes
set www disabled=yes
set ssh disabled=yes
set api disabled=yes
set winbox port=8200
set api-ssl disabled=yes
/ip smb shares
set [ find default=yes ] disabled=yes
/ppp secret
add name=test password=test service=l2tp
/system identity
set name=MoradiLab
/system ntp client
set enabled=yes server-dns-names=ntp.pool.org
/system watchdog
set automatic-supout=no watchdog-timer=no
/tool bandwidth-server
set enabled=no
