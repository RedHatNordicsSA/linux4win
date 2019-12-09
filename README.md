# Linux workshop for Windows administrators

Workshop items:
- Operations walkthrough (using Cockpit)
  - Storage management
    - Creating new filesystem
    - Expanding a filesystem
  - Enable/disable/restart services
  - Network configuration
    - Static ip assignment
    - Dynamic ip assignment
  - Firewall management
    - Enable service openings in firewall
    - Open single port in firewall
  - User management (with Active Directory)
    - Assigning privileges to users (Run as Administrator configuration)
    - Setting up access controls
  - Connecting a server to Active Directory for authentication (no GPOs)
  - Troubleshooting
    - View logs
    - View active processes
  - Software management
    - Installing software
    - Updating software

- Assignments:
  - Setup server to function in Enterprise environment
    - Create a "golden image" using Image-builder
    - Clone a server from the golden image
    - Connect the cloned server to the Active Directory for Authentication
    - Configure networking
    - Configure administrator rights to correct groups
    - Install base packages needed
    - Update the golden image with all additions
  - Installing MSSQL
    - Install repo that contains MSSQL
    - Install MSSQL binaries from the repo
    - Set MSSQL service to start at boot
    - Open firewall for correct port
  - Management of several servers using Cockpit
    - Create a ssh key to use for authentication
    - Distribute the ssh key to the servers to be managed
    - Add servers to the graphical user interface(GUI)
    - Perform tasks on many servers using the GUI
- Extra tasks (if you have time)
  - Using Ansible to manage several servers

