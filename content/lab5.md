# User management

In this lab, you will learn how to manage users and groups in Linux. You will also try to connect your Linux server to Active Directory.

## Intro to user management in Linux

Just as in Windows, users are members of groups and this works as a basics for access controls in many systems. Users also has home directories and system settings that applies to them specifically. By default, a Linux server only uses local users. The default administrator user in Linux is as mentioned before, called ```root```. 

When managing more than a handful of systems, connecting them to some sort of centralized identity and authentication source is recommneded. In the Linux world, there is no single identity and authentication solution which most often is used. Red Hat Enterprise Linux includes an identity and authentication solution, called ```Red Hat Identity Management (Red Hat IDM)``` , if you do not have one.

:star: [If you want to read more about ```Red Hat IDM```, click here.](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/considerations_in_adopting_rhel_8/identity-management-news_considerations-in-adopting-rhel-8 "Red Hat Enterprise Linux 8 documentation page")  

Even though Red Hat Enterprise Linux includes a solution for centralized user management, most commonly at large enterprises - Windows and Linux systems share solutions. It is common to use Active Directory, also for Linux systems.  

## User management (with Active Directory)

We will now look at how user management works in Linux using Active Directory. You will learn how to connect a Linux server to Active Directory for centralized identity and authentication. Please note that group policies or GPOs are not supported for Linux. Any group policies you want to apply needs to be done by a separate configuration system. Luckily, there are many available for Linux, such as ```ansible```. You can also get central policy management of Red Hat Enterprise Linux systems using ```Red Hat Satellite```.

:star: [Read more about Ansible, here: https://www.ansible.com](https://www.ansible.com "Ansible homepage")
:star: [Read more about Red Hat Satellite, here: https://www.redhat.com/en/technologies/management/satellite](https://www.redhat.com/en/technologies/management/satellite "Satellite homepage")

There are two different ways to use Active Directory for user management of Linux systems.

* Connecting Linux systems directly to Active Directory
* Using a system such as Red Hat Identity Management (IDM) to synchronized with Active Directory and then connecting Linux system to that system in turn

The second option is less common and more complicated. In this lab, we will deal with the first option, connecting a Red Hat Enterprise Linux system directly to Active Directory.

## Connecting your server to Active Directory (no GPOs)

To connect to Active Directory, we first need to install some software on our server.

:boom: Go to the ```Terminal``` menu item on the left side menu and type in below command to install the required software.

```
sudo dnf install realmd
```

:boom: Next, click on the ```System``` menu option on the top of the left side menu.  Locate the button on the system where is says **Join Domain** in blue and click on that to proceed to the join domain wizard.

![system user interface of cockpit](images/interface_system.png)


:boom: Fill in the domain address as shown below and wait for the discovery to complete - indicated by the text ```Contacted domain```. In this example, we will not specify the OU to put the computer-account in. Continue and fill in the username/password of an account that can add computers and click ```Join```. Domain admin name and password for this lab is:

```
Username: Administrator
Password: Password1
```

![join domain wizard](images/joindomain.png)

## Assigning privileges to users (Run as Administrator configuration)

For users that are local this is a simple opperation. Locate the Accounts option in the menu to your left. And click:

![accounts interface of cockpit](images/accounts.png)

This is where you can add more local accounts. Please press the Create New Account button and look at your options:

![rhel account options](images/createaccount.png)

Press Cancel to close the add new user dialog and locate the entry called **rhel** and click.

![rhel account options](images/accountrhel.png)

Here you can set all kind of options including the ability to administer the server (checkbox called Server Administrator)

But none of the accounts from Active Directory is visible here. This will be addressed in future releases of the web console.

So right now you will have to use the Terminal. Please click the terminal option in the menu on your left.

Type the following command into the terminal to get information regarding an account

```
id vsda@linux4win.local
```
Out comes info about the user like groups that is member of.
```
uid=579601105(vsda@linux4win.local) gid=579600513(domain users@linux4win.local) groups=579600513(domain users@linux4win.local),579601110(minions@linux4win.local)
```
In order for this account to be able to administer this computer we will need to add it to the local wheel group. This is done by the command shown below:
```
sudo usermod --append -G wheel vsda@linux4win.local
```
Please type the password of the account. This works on smaller scale. Not so much on larger scale where you most likely use Groupmembership for these kind of things. So in order to set this up we are going to create a file in a special location. 
```
ls -l /etc/sudoers.d/
```
Any files found in this location will be added to the sudoers rules that enables users to run commands as root (which is the highest level of access available on linux). So we are going to create one. This can be done in many ways. In this example we will use nano. And it is not installed. So we start there. 
```
sudo yum install nano
```
Then lets make the file
```
sudo nano /etc/sudoers.d/minions
```
```
%minions@linux4win.local ALL=(ALL) NOPASSWD: ALL
```
Now we need to set rights on the file. All files in the sudo system should have these:
```
-r--r-----. 1 root root 29 13 nov  2015 minions
```
So in order to set this we use chmod
```
sudo chmod 0440 /etc/sudoers.d/minions
```
So to test ths you will need to login as another account and try to run anything with sudo. Can be done like this:
```
sudo su - hger@linux4win.local
```
And then try a sudo command:
```
sudo ls /etc
```
You should get no errors

## Setting up access controls

Now we have the server connected to Active directory. And we have set how can become Administrator (root). But anyone in the organization can login to this system. First we are going to look at setting this on an ssh level, ssh is the way to remote manage any linux system. So we are going to add this to the end of the file which holds configuration for the ssh service.
```
sudo nano /etc/ssh/sshd_config
```
And add these two lines at the end
```
AllowGroups minions@linux4win.local
DenyUsers administrator administrator@linux4win.local
```
So now you have to be a member of the minions@linux4win.local Security Group in Active Directory to be allowed to login using ssh. Also we blocked access to the generic Administrator account which can pose a security issue if used.
Now we need to restart the sshd service. This can be done using the Services part of the menu.
Filter for ssh:
![restart sshd service](images/sshdservview.png)
Then click on sshd.service and restart the service.


Continue to [lab 6](lab6.md)

Back to [index](thews.md)