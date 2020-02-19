# Linux workshop for Enterprise administrators

Here is the explanation of your [environments](content/lab0.md)

Workshop items:
- Operations walkthrough (using Cockpit)
  - [**lab1** *Software management*](content/lab1.md)
    - Installing software
    - Updating software
  - [**lab2** *Storage management*](content/lab2.md)
    - Creating new filesystem
    - Expanding a filesystem
  - [**lab3** *Service management*](content/lab3.md)
    - Start a service
    - Enable a service (survives reboot)
    - Check status of a service
    - Disable a service
  - [**lab4** *Network configuration*](content/lab4.md)
    - Static ip assignment
    - Dynamic ip assignment
    - Enable service openings in firewall
    - Open single port in firewall
  - [**lab5** *User management (with Active Directory)*](content/lab5.md)
    - Connecting a server to Active Directory for authentication (no GPOs)
    - Assigning privileges to users (Run as Administrator configuration)
    - Setting up access controls
  - [**lab6** *Troubleshooting*](content/lab6.md)
    - View logs
    - View active processes

- Assignments:
  - [**assign1** *Create image for use in the cloud or virtual*](content/assign1.md)
    - Create a "golden image" using Image-builder
    - Add local users to the golden image
    - Create image for your selected hypervisor
  - [**assign2** *Installing MSSQL*](content/assign2.md)
    - Install repo that contains MSSQL
    - Install MSSQL binaries from the repo
    - Set MSSQL service to start at boot
    - Open firewall for correct port
  - [**assign3** *Management of several servers using Cockpit*](content/assign3.md)
    - Create a ssh key to use for authentication
    - Distribute the ssh key to the servers to be managed
    - Add servers to the graphical user interface(GUI)
    - Perform tasks on many servers using the GUI
  - [**assign4** *Management of several servers using Ansible*](content/assign4.md)
    - Setup of ansible master
    - Run ad hoc commands against your windows server

