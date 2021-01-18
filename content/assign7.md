# Package management RHEL8

Now we are going to look a little deeper at how package management has changed from RHEL 7 to RHEL 8.

There is a fundamental technology change in RHEL8 where the old ```yum``` system is replaced with ```dnf```. However that is more or less all you need to know. We have worked real hard to make the almost all uses of the old command transparently work with the new. You can continue to use any yum command you regularly use and most likely any script you have will just work.

**However**

## Gone are the channels only repositories remain

So in RHEL 7 (and earlier versions) we published packages in channels. And you had to figure out what package is in what channel. Then you would haveto attach channels to systems. Example below:
```
subscription-manager repos --list
subscription-manager repos --enable rhel-7-server-optional-rpms
```

So in RHEL 8 we have simplified this into **2** repositpories only:
```
BaseOS
```
Content in the BaseOS repository is intended to provide the core set of the underlying OS functionality that provides the foundation for all installations. 

```
AppStream
```
Content in the Application Stream repository includes additional user space applications, runtime languages, and databases in support of the varied workloads and use cases.

But many customers still want to select either this version of an application or that. We solve this by adding ```modules``` into the ```AppStream``` repository. Modules are collections of packages representing a logical unit: an application, a language stack, a database, or a set of tools. These packages are built, tested, and released together.

Lets now look at how this can work

## Working with AppStream's

All of this work will be done using the terminal. Please locate the Terminal.

Lets by doing something quite common, try to run the python interpreter
```
python
-bash: python: command not found
```
What? No python? Well yes there is a default python installed at:
```
/usr/libexec/platform-python
Python 3.6.8 (default, Aug 18 2020, 08:33:21) 
[GCC 8.3.1 20191121 (Red Hat 8.3.1-5)] on linux
Type "help", "copyright", "credits" or "license" for more information.
>>> 
CTRL-D
```
But this is the python for the system and this is a good thing as many system components depend on python. Now there is a "system" python that is managed by Red Hat. **Do not attempt to change the system python**

Instead we will install a python of your choise. Lets start by listing the available pythons.
```
yum module list
```
This will output a long list of modules available to install. We will make this list shorter. By adding a simple filter:
```
yum module list python*
``` 
The output is now way shorter (and I have shortened it even more)

Red Hat Enterprise Linux 8 for x86_64 - AppStream (RPMs)
Name | Stream | Profiles | Summary
--- | --- | --- | ---
python27 | 2.7 [d]|  common [d] | Python programming language, version 2.7
python36 | 3.6 [d] | build, common [d] | Python programming language, version 3.6
python38 | 3.8 [d] | build, common [d] | Python programming language, version 3.8


So now you get a list of available python interpreters to install on your system for you to run or develop your python applications.

Back to [index](thews.md)
