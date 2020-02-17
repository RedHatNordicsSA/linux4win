#!/bin/bash

#preps the first cockpit server
useradd rhel
echo "linux4winPass2020" | passwd rhel --stdin
usermod -aG wheel rhel
echo "rhel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/rhel
chmod 0440 /etc/sudoers.d/rhel

#install enable and open firewall for cockpit
yum install firewalld cockpit-composer cockpit bash-completion -y
systemctl enable --now firewalld
systemctl enable --now cockpit.socket
firewall-cmd --add-service=cockpit
firewall-cmd --add-service=cockpit --permanent

#fix for ansible broken winrm
yum install python3-pip -y
pip3 install pywinrm
cp -r /usr/local/lib/python3.6/site-packages/* /usr/lib/python3.6/site-packages/
