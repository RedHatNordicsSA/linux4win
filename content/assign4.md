# Management of several servers using Ansible

In the previous assignment you added an additional server to the ```Web console```. This enabled you to manage two servers using the web console. In this chapter, you will get introduced to the world's currently most popular automation framework, Ansible.

## Intro to Ansible

If you are handling dussins of servers, doing things such as installing software and changing configuration quickly becomes a cumbersome task which will require more people to manage the systems while also affecting time-to-deliver for the various tasks.

To handle a larger amount of systems, you will need to adapt an automation framework to handle the previously mentioned challenges.

There are many automation frameworks out there, such as Puppet, Chef and Salt. The currently most popular automation framework in the world is called Ansible.

![ansible logo](images/ansiblelogo.png)

The reason why Ansible has risen to popularity, is its lower adoption threshhold (automation is pretty close to written language) and its clientless nature (you do not have to install anything on a system to automate it). Ansible's clientless nature underpins Ansible's ability to automate all things, including all current Operating Systems, network equipment and even IoT devices such as lightbulbs. 

:thumbsup: When implementing Ansible in an enterprise on a larger scale, you will need some type of management solution to solve collaborative and security related challenges, such as ```Red Hat Ansible Tower```, or its upstream open source project, ```AWX```. We will not cover that in this lab, but only focus on some quick hands on experience.

## Setup of ansible master

We will choose our first (where we have spend most of our time on, so far) Red Hat Enterprise Linux server as an Ansible master, the server which we'll do Ansible automation from.

:boom: To start, we will install the ansible software needed. In the ```web console```, go to that server, open the ```Terminal``` and install the required software.
```
sudo dnf install ansible
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

If you look into this file you will see lots of good instructions:
```
less /etc/ansible/hosts
```

:boom: To exit less you press the **Q** button. So this information is good to shave for the future. Let's make a copy of that file
```
sudo cp /etc/ansible/hosts /etc/ansible/hosts.backup
```

:boom: So now we have a backup file we can lookup if needed. Now it is time to fill the file with simple context. Type below commands to put your Red Hat Enterprise Linux server into the inventory file:
```
sudo su -
echo "[linux]" > /etc/ansible/hosts
echo "ip.address.of.linuxserver1" >>/etc/ansible/hosts
echo "ip.address.of.linuxserver2" >>/etc/ansible/hosts
exit
```

:exclamation: Please note the double ```>>``` on the two last lines.

## Run ad hoc commands against your linux servers

:boom: First we're going to tell SSH that we trust that these servers cryptographic fingerprints are correct. Type the following to do that:

```
grep -v "^\[" /etc/ansible/hosts|xargs ssh-keyscan -H >> ~/.ssh/known_hosts
```

:boom: Now it is possible to do stuff on both (but this can be a looooong list of servers) servers in one go. Let's start by verifying that we can connect by this command
```
ansible all -m ping --ask-pass
```

:boom: Next up lets run a command on the servers, and check what version of Red Hat Enterprint Linux they are running:
```
ansible all -m shell -a 'cat /etc/redhat-release' --ask-pass
```

:boom: With this command we find out what release of Red Hat Enterprise Linux these servers are running. Imagine this being a loooooong list of servers. You now have some insights into you entire fleet just using one command that you can alter indefinite. So let's just update stuff.
```
ansible all -m shell -a 'dnf check-update' --ask-pass --become
```

:boom: This command list all available updates for any system. Now most likely you do not get any updates since we have already done the patching using the web-ui. But if there where any all you needed to do was run this command to install them all.
```
ansible all -m shell -a 'dnf update -y' --ask-pass --become
```

Once the command is done you have patched two servers using one command.

#### SSH keys

:star: :boom: Did you get quite tired of typing passwords? You can also use ssh keys.

:star: :boom: Do not enter a password for the key. Type below command (just press enter for all questions):
```
ssh-keygen
```

:star: :boom: Copy the key to your servers by running below command:
```
for item in $(grep -v "^\[" /etc/ansible/hosts); do ssh-copy-id rhel@$item; done
```

:star: :boom: Now try and redo some of the previous tasks. Nice isn't it?

:thumbsup: Please note that when using a SSH key, protecting the key become paramout. AWX (https://github.com/ansible/awx) and Red Hat Ansible Tower (https://www.ansible.com/products/tower) are ways you can protect SSH keys from unauthorized access and allow you to share use of a key, without sharing the key itself.

## Run ad hoc commands against your windows server

Now let's see if we can do this also with our windows server. On the server we do not have to do anything it is already prepared for ansible management. Here you find info about what was done to enable this:

[Windows server setup](https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html)

Now we need to add some stuff to the hosts file in order to be able to manage windows servers.

:boom: So let's edit the hosts file again:
```
/etc/ansible/hosts
```
:boom: Copy the entire block below, this will add those lines to that file. 

:exclamation: Do not forget to change the ip.address.of.winserver1 to your actual ip address.
```
sudo su -
cat >> /etc/ansible/hosts << EOF
[win]
ip.address.of.winserver1

[win:vars]
ansible_user=.\wsadder
ansible_password=Password1
ansible_connection=winrm
ansible_winrm_transport=ntlm
ansible_winrm_server_cert_validation=ignore
EOF
exit
```

What we did was add a group ```[win]``` and some variables for that group ```[win:vars]```
I know it is not the safest to have password in clear text. To make it safer you can use ansible-vault.

:boom: Once you have added the stuff to the hosts file it is time to test if stuff works:

```
ansible win -m win_ping
```

You should get some kind of result indicating that you can connect to the remote windows server.

If that is successful then perhaps let's make some very common tasks like install SecurityUpdates only, there are three categories, SecurityUpdates,CriticalUpdates and UpdateRollups.

:boom: So we are going to just install the first category (this to save some time).
```
ansible win -m win_updates -e category_names=SecurityUpdates -e reboot=yes
```

:boom: If you need to reboot the win server use this command
```
ansible win -m win_reboot
```

This module are very well documented [here](https://docs.ansible.com/ansible/latest/modules/win_updates_module.html)


Continue to [assignment 5](assign5.md)

Back to [index](thews.md)

