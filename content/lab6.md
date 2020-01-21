# Troubleshooting
This is quite the broad topic. But logs usually help a lot when trying to figure out what a problem can be. We have already installed a service that is not starting as expected.

## View active services
To look at the running services you just locate the **Services** option in the menu on your left. So please click that now
![services user interface of cockpit](images/services_interface.png)

You can filter services by their status. Click where it says **All**

![services filter](images/services_filter.png) 
Select Enabled to view services that are set to start at boot.
Disabled are services that are installed but not set to start at boot.
Static are *********

You may see a service that is in **Failed** state. This should be the chronyd service. Chronyd is the default NTP service on Red Hat Enterprise Linux. You should already have a good idea why it is not working. Just click on the entry in the list to view more details.

![services details](images/failed_chronyd.png)
## View logs
To look at any logs collected on this system you just locate the **Logs** option in the menu on your left and click on it.

![logs user interface of cockpit](images/interface_logs.png)

Here you can filter on severity. Click the menu item where it says **Severity**
![severity details](images/severity_menu.png)

Select a level below Error like **Info and above**. And look at the other options for log-level.

Now you should have a pretty good idea of what the problem can be and even which file the error is located in. So in order to fix this we need to go to the terminal and edit the file.
When back in terminal you need to edit that file.
```
sudo nano /etc/chrony.conf
```
In this file on line 3 (which was also stated in the logs) there is a typo. this line:
```
pool 2.rhel.pool.ntp.org ibarst
```
Should look like this:
```
pool 2.rhel.pool.ntp.org iburst
```
Now when you have fixed the typo go back to menu item Services and restart the chronyd service please.

Continue to [assignment 1](content/assign1.md)

Back to [index](../README.md)