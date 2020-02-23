# Management of several servers using Ansible

So in the previous assignment you added a server to the interface. This enabled you to manage two servers using the web console. But it is still not super efficient way to manage lots of servers.

Lets say you have 20 linux servers in your infrastructure. And a serious software vulnerability is found in a base-package present in all these 20 servers. Now you will need to click 20 times on the update software button.

So instead we propose using an automation framework that can help relive you of repetative tasks like updating software by hand.

![ansible logo](images/ansible-logo.png)

## Setup of ansible master

:boom: To start out we will install the ansible software needed on the second server. So start by going to that server. Then open the terminal and install it
```
yum install ansible
```

:boom: Once it is installed please verify that it works by running this command:
```
ansible --version
```

Now you are ready to add some servers to be managed. This is done by createing a host file. It can be stored anywhere and is in its simplest form a list of ip-addresses or FQDN's.

:boom: We are going to edit the default host file that is located here:
```
/etc/ansible/hosts
```

If you look into this file you will see lots of good instuctions:
```
less /etc/ansible/hosts
```

:boom: To exit less you press the **Q** button. So this information is good to shave for the future. Lets make a copy of that file
```
cp /etc/ansible/hosts /etc/ansible/hosts.backup
```

:boom: So now we have a backup file we can lookup if needed. Now it is time to fill the file with simple context:
```
ip.address.of.linuxserver1
ip.address.of.linuxserver2
```

## Run ad hoc commands against your linux servers

:boom: Now it is possible to do stuff on both (but this can be a looooong list of servers) servers in one go. Lets start by verifying that we can connect by this command
```
ansible all -m ping -u rhel --ask-pass
```

:boom: Next up lets run a command on the servers:
```
ansible all -m shell -a 'cat /etc/redhat-release' -u rhel --ask-pass --become-user rhel
```

:boom: With this command we find out what release of Red Hat Enterprise Linux these servers are running. Imagine this beeing a loooooong list of servers. You now have some insights into you entire fleet just using one command that you can alter indefinite. So lets just update stuff.
```
ansible all -m shell -a 'yum check-update' -u rhel --ask-pass --become-user rhel
```

:boom: This command list all available updates for any system. Now most likely you do not get any updates since we have already done the patching using the web-ui. But if there where any all you needed to do was run this command.
```
ansible all -m shell -a 'yum update -y' -u rhel --ask-pass --become-user rhel
```

Once the command is done you have patched two servers using one command.

## Run ad hoc commands against your windows server

Now lets see if we can do this also with our windows server. On the server we do not have to do anything it is already prepared for ansible management. Here you find info about what was done to enable this:

[Windows server setup](https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html)

Now we need to add some stuff to the hosts file in order to be able to manage windows servers.

:boom: So lets edit the hosts file again:
```
/etc/ansible/hosts
```
:boom: And add all of these lines somewhere
```
[win]
ip.address.of.winserver1

[win:vars]
ansible_user=.\wsadder
ansible_password=Password1
ansible_connection=winrm
ansible_winrm_transport=ntlm
ansible_winrm_server_cert_validation=ignore
```

What we did was add a group [win] and some variables for that group [win:vars]
I know it is not the safest to have password in clear text. To make it safer you can use ansible-vault.

:boom: Once you have added the stuff to the hosts file it is time to test if stuff works:

```
ansible win -m win_ping
```

You should get some kind of result indicating that you can connect to the remote windows server.

:boom: If that is successful then perhaps lets make some very common tasks like check for updates using Microsoft Updates. Be prepared that it may take quite some time to get back the list
```
ansible win -m win_updates -e state=searched
```

:boom:  Now we see that there are some updates to lets install them
```
ansible win -m win_updates -e category_names=['SecurityUpdates, CriticalUpdates, UpdateRollups'] -e reboot=yes
```

:boom: If you need to reboot the win server use this command
```
ansible win -m win_reboot
```

Back to [index](thews.md)

