#!/bin/bash

#preps the first cockpit server
useradd rhel
echo "redhat" | passwd student --stdin
usermod -aG wheel rhel
echo "rhel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/rhel
chmod 0440 /etc/sudoers.d/rhel

#install enable and open firewall for cockpit
yum install cockpit-composer cockpit cockpit-dashboard bash-completion -y
systemctl enable --now cockpit.socket
firewall-cmd --add-service=cockpit
firewall-cmd --add-service=cockpit --permanent

#prep for lab2
mkdir /mnt/myvol
chmod 0755 /mnt/myvol

#prep for lab 4
yum install https://dl.fedoraproject.org/pub/epel/7/x86_64/Packages/p/python2-html2text-2019.8.11-1.el7.noarch.rpm -y

#prep for lab 5
yum install realmd oddjob oddjob-mkhomedir sssd adcli samba-common-tools -y

# Set dns=none for NetworkManager
sed -i -e "s/\[main\]/\[main\]\\ndns=none/" /etc/NetworkManager/NetworkManager.conf
systemctl restart NetworkManager

DNSIP=ADIPADDRESS
sed -i -e "s/# Generated by NetworkManager/nameserver $DNSIP/g" /etc/resolv.conf

#prep for lab 6
sed -i 's/iburst/ibarst/g' /etc/chrony.conf
systemctl restart chronyd  >/dev/null 2>&1
