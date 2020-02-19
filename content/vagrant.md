# Test or run using vagrant

So in order to try this you need to have git, vagrant and ansible installed on your compjuter.

Then follow these steps:

```
git clone https://github.com/RedHatNordicsSA/linux4win.git
cd linux4win/vagrant/linux4win
vagrant up
```

You will now get 4 servers that should have these ip addresses:

```
10.0.1.4 (main cockpit instance)
10.0.1.5 (second cockpit instance)
10.0.1.6 (Active Directory server)
10.0.1.7 (Windows client)
```

Back to [index](../thews.md)