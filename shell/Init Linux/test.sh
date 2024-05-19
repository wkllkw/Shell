#!/bin/bash

#配置yum仓库
if test mkdir /etc/yum.repos.d/backup
then
mv /etc/yum.repos.d/* /etc/yum.repos.d/backup
fi

cat >/etc/yum.repos.d/Centos-Base.repo <<EOF
[base]
name=CentOS-\$releasever - Base
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/\$releasever/os/\$basearch/
	https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/os/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
	https://mirrors.tuna.tsinghua.edu.cn/centos/RPM-GPG-KEY-CentOS-7

[updates]
name=CentOS-\$releasever - Updates
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/\$releasever/updates/\$basearch/
	https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/updates/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
	https://mirrors.tuna.tsinghua.edu.cn/centos/RPM-GPG-KEY-CentOS-7

[extras]
name=CentOS-\$releasever - Extras
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/\$releasever/extras/\$basearch/
	https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/extras/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
	https://mirrors.tuna.tsinghua.edu.cn/centos/RPM-GPG-KEY-CentOS-7


[centosplus]
name=CentOS-\$releasever - Centosplus
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/\$releasever/centosplus/\$basearch/
	https://mirrors.tuna.tsinghua.edu.cn/centos/\$releasever/centosplus/\$basearch/

gpgcheck=1
enabled=0
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
	https://mirrors.tuna.tsinghua.edu.cn/centos/RPM-GPG-KEY-CentOS-7


[contrib]
name=CentOS-\$releasever - Contrib
failovermethod=priority
baseurl=http://mirrors.aliyun.com/centos/\$releasever/contrib/\$basearch/
gpgcheck=1
enabled=0
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
	https://mirrors.tuna.tsinghua.edu.cn/centos/RPM-GPG-KEY-CentOS-7


[epel]
name=epel
failovermethod=priority
baseurl=http://mirrors.aliyun.com/epel/7/\$basearch
enabled=1
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
EOF

#网络配置
#恢复默认网卡名(即eth0)
sed -i  '6s/quiet"/quiet net.ifnames=0"/' /etc/default/grub  
grub2-mkconfig -o /boot/grub2/grub.cfg
#配置网卡
mv /etc/sysconfig/network-scripts/ifcfg-ens33 /etc/sysconfig/network-scripts/ifcfg-ens33.bak
cat >/etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=static
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=eth0
DEVICE=eth0
ONBOOT=yes
IPADDR=10.0.0.5
NETMASK=255.255.255.0
GATEWAY=10.0.0.2
DNS=114.114.114.114
EOF

#配置.vimrc
yum install vim -y

cat >~/.vimrc <<EOF
set nu
set ts=4
set ai      
syntax on                                                                   
set cul      
set paste   
EOF
