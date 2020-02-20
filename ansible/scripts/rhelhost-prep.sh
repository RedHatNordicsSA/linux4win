#!/bin/bash

RHN_ACCOUNT=THEACCOUNT
RHN_PASSWORD=THEPASSWORD

#preps the first cockpit server
useradd rhel
echo "linux4winPass2020" | passwd rhel --stdin
usermod -aG wheel rhel
echo "rhel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/rhel
chmod 0440 /etc/sudoers.d/rhel

subscription-manager register --username=$RHN_ACCOUNT --password=$RHN_PASSWORD
if [ "$?" -ne 0 ]; then 
        sleep 5
        subscription-manager register --username=$RHN_ACCOUNT --password=$RHN_PASSWORD
        if [ "$?" -ne 0 ]; then 
                sleep 5
                subscription-manager register --username=$RHN_ACCOUNT --password=$RHN_PASSWORD 
                if [ "$?" -eq 0 ]; then 
                        rm -f /etc/yum.repos.d/*rhui*
			dnf clean all
                else
                        echo "I tried 3 times, I'm giving up."
                        exit 1
                fi
        else
                rm -f /etc/yum.repos.d/*rhui*
		dnf clean all
        fi
else
        rm -f /etc/yum.repos.d/*rhui*
	dnf clean all
fi

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

#uncomment before live
#rm -rf /var/lib/cloud/instance/scripts/*
