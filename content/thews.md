# Linux workshop for Enterprise administrators

:exclamation: You need to complete the labs in strict sequential order, as things you do early on will be used later on.

Workshop items:
- Welcome to the lab, here you find the [prerequisites](lab0.md) of the lab.

- Operations walkthrough (using the web console)
  - [**lab1** *Software management*](lab1.md)
    - Learn how software is managed in Linux, install applications and more.
  - [**lab2** *Storage management*](lab2.md)
    - More the basic of Linux storage management, including creating filesystems and more.
  - [**lab3** *Service management*](lab3.md)
    - Step out of this lab with a basic understanding about service management, including some hands on experience.
  - [**lab4** *Network configuration*](lab4.md)
    - Learn about how to manage and troubleshoot networking in Linux.
  - [**lab5** *User management*](lab5.md)
    - Learn how to do user management at small and large scale, including handling priviledge esclation and access controls. 
  - [**lab6** *Troubleshooting*](lab6.md)
    - Use some of the knowledge you've gained and troubleshoot a failing service, also try out of neat tooling.
- Assignments:
  - [**assign1** *Create image for use in the cloud or virtual*](assign1.md)
    - Create a "golden image" using Image-builder
    - Add local users to the golden image
    - Create image for your selected hypervisor
  - [**assign2** *Installing MSSQL*](assign2.md)
    - Install repo that contains MSSQL
    - Install MSSQL binaries from the repo
    - Set MSSQL service to start at boot
    - Open firewall for correct port
  - [**assign3** *Management of several servers using web console*](assign3.md)
    - Create a ssh key to use for authentication
    - Distribute the ssh key to the servers to be managed
    - Add servers to the graphical user interface(GUI)
    - Perform tasks on many servers using the GUI
  - [**assign4** *Management of several servers using Ansible*](assign4.md)
    - Setup of ansible master
    - Run ad hoc commands against your windows server

