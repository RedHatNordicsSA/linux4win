# Installing Microsoft SQL on Red Hat Enterprise Linux

An upcoming and more and more common workload on Red Hat Enterprise Linux is maybe a bit surprisingly Microsoft SQL server.

Starting ```Microsoft SQL Server 2017```, Microsoft supports the use of Red Hat Enterprise Linux (7 and 8) as an operating system. Starting ```Microsoft SQL Server 2019```, you may even run it as a container on Red Hat's Kubernetes platform, ```OpenShift```.

![microsoft sql server](images/mssql.png)

Please note that the SQL Server Management Studio is still Windows only. There are tools to interact with the SQL server though, such as Visual Studio Code, which comes with a MS SQL extension.

:star: To get information about how to install the MS SQL extention in Visual Studio Code, see below link:

https://docs.microsoft.com/en-us/sql/visual-studio-code/sql-server-develop-use-vscode?view=sql-server-ver15

## Install repo that contains MSSQL

First off, we will point our system to the Microsoft SQL software repository, so that our system can find and install the software.

:boom: Go back to the ```Terminal``` menu option, available in the left side menu and run below command to install the software respository definition:

```
sudo curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/8/mssql-server-2019.repo
```

What this command does is to download the software repository file and put it into the directory  ```/etc/yum.repos.d``` where ```dnf``` will look when you run the installation command later on.

:boom: Have a look at the existing software repository files in place on your system by running below command:
```
ls -l /etc/yum.repos.d/
```
Which outputs something like this:
```
-rw-r--r--. 1 root root    231 Jan 24 14:22 mssql-server.repo
-rw-r--r--. 1 root root 130564 Jan 24 08:00 redhat.repo
```
As you can see from the list above there is two files (at least) an one is named **mssql-server.repo** so this file contains the settings needed to install software from microsoft.

## Install MSSQL binaries from the repo

Now its time to install the MSSQL server. This is also done using the terminal.

:boom: Run the ```dnf``` command to install the MS SQL server on your system, as shown below:

```
sudo dnf install mssql-server
```

Type ```y``` when asked and MS SQL server and it's dependencies get's installed.

When the installation is done it is time to configure the SQL server with the SA password and such.

:boom: Run below command and follow the instructions which follows:
```
sudo /opt/mssql/bin/mssql-conf setup
```

## Set MSSQL service to start at boot

You can now use the services part of the menu to your left to setup the service to be **Enabled** which will then start the MSSQL server at boot. Once you have enabled it, then reboot the machine to make sure you have setup correctly.

## Open firewall for correct port

And you will use the firewall part from the Networking menu on your left to open the port for MSSQL
```
port=1433
```

Continue to [assignment 3](assign3.md)

Back to [index](thews.md)
