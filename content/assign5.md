# Container tooling in RHEL8

In this chapter, you will get an introduction to the tools that are available in the RHEL 8 release. There is also a simple tool to install that creates aliases to the correct tools so you can continue to use any ```docker command``` you are currently basing scripts and such on.

## Introduction to the container tools

So we and several other players in the open-source world have created tools to completely replace any docker commands you might have used ever. Not done yet but pretty close indeed. There are three tools we will look at in this section:

- **podman**
- **buildah**
- **skopeo**

## podman

This is the first tool we look at, its is simply a replacement for most docker commands connected to the management of containers on a single host, like:

- ```search``` (search for images in any configured repository)
- ```pull``` (download an container-image from any repository to local)
- ```run``` (start any container-image from the local store)
- ```image``` (manage the local container-images)
- ```ps``` (lists any running or stopped containers on the local host)
- ```logs``` (inspects logs from containers running on the local host)
- ```rm``` (removes any running or stopped containers from the local host)

So for most people this would be the goto tool for consuming ready-made container images.

## buildah

The second tool is buildah, as the name in a sense implies this is the tool for building your own container-images.

- ```build``` (Calls buildah bud, uses Dockerfile)
- ```commit``` (commmits any changes done in a running container to the container-image stored locally)
- ```pull``` (download an container-image from any repository to local)
- ```push``` (upload a container-image from local to remote repository)
- ```tag``` (add an additional name to a local container-image)

So the buildah tool is for building your own container images. It also adds features not present in the docker command, see [here](https://www.redhat.com/en/blog/say-hello-buildah-podman-and-skopeo) for additional info. 


## skopeo

And the last tools is skopeo. Skopeo is all about working with images in remote repositories

- ```login(out)``` (login or out of any container registry)
- ```inspect``` (get more details of a container-image from any repository)
- ```copy``` (copy a container-image from one location to another)
- ```delete``` (delete any container-image in any container registry)

This would be the more specialized of the tools, mainly for manipulating container registries both local and remote.

## installing on RHEL8

So now we will look at howto install these tools on RHEL 8

:boom: All commands can be run in any terminal. 
```
sudo yum module install -y container-tools
```

And that should be that. Now all the container tools are available.

## Getting help
To get some help and find out how Podman is working, you can use the help:
```
podman --help
podman <subcommand> --help
```
For more details, you can review the manpages:
```
man podman
man podman-<subcommand>
```
Please also reference the Podman Troubleshooting Guide to find known issues and tips on how to solve common configuration mistakes.

## Searching, pulling & listing images
Podman can search for images on remote registries with some simple keywords.
```
podman search <search_term>
```
You can also enhance your search with filters:
```
podman search httpd --filter=is-official
```
Downloading (Pulling) an image is easy, too.
```
podman pull registry.access.redhat.com/rhscl/httpd-24-rhel7
```
After pulling some images, you can list all images, present on your machine.
```
podman images
```
:exclamation: Podman searches in different registries. Therefore it is recommend to use the full image name (registry.access.redhat.com/rhscl/httpd-24-rhel7 instead of php) to ensure, that you are using the correct image.

## Running a container
This sample container will run a very basic httpd server that serves only its index page.
```
podman run -dt -p 8080:8080/tcp registry.access.redhat.com/rhscl/httpd-24-rhel7
```
:exclamation: Because the container is being run in detached mode, represented by the -d in the podman run command, Podman will print the container ID after it has executed the command. The -t also adds a pseudo-tty to run arbitrary commands in an interactive shell.

:exclamation: We use port forwarding to be able to access the HTTP server.

## Listing running containers
The podman ps command is used to list created and running containers.
```
podman ps
```
:exclamation: If you add -a to the podman ps command, Podman will show all containers (created, exited, running, etc.).

## Testing the httpd container
As you are able to see, the container does not have an IP Address assigned. The container is reachable via it’s published port on your local machine.
```
curl http://localhost:8080
```
From another machine, you need to use the IP Address of the host, running the container.
```
curl http://<IP_Address>:8080
```
:exclamation: Instead of using curl, you can also point a browser to http://localhost:8080.

## Inspecting a running container
You can “inspect” a running container for metadata and details about itself. podman inspect will provide lots of useful information like environment variables, network settings or allocated resources.

Since, the container is running in rootless mode, no IP Address is assigned to the container.
```
podman inspect -l | grep IPAddress
            "IPAddress": "",
```
:exclamation: The -l is a convenience argument for latest container. You can also use the container’s ID or name instead of -l or the long argument --latest.

## Viewing the container’s logs
You can view the container’s logs with Podman as well:
```
podman logs -l

127.0.0.1 - - [04/May/2020:08:33:48 +0000] "GET / HTTP/1.1" 200 45
...
```

## Viewing the container’s pids
You can observe the httpd pid in the container with podman top.
```
podman top -l

USER      PID   PPID   %CPU    ELAPSED           TTY     TIME   COMMAND
default   1     0      0.000   3m26.775200608s   pts/0   0s     httpd -D FOREGROUND 
default   44    1      0.000   3m26.777402402s   pts/0   0s     httpd -D FOREGROUND 
...
```
## Stopping the container
You may stop the container:
```
podman stop -l
```
You can check the status of one or more containers using the podman ps command. In this case, you should use the -a argument to list all containers.
```
podman ps -a
```
## Removing the container
Finally, you can remove the container:
```
podman rm -l
```
:exclamation: You can verify the deletion of the container by running podman ps -a.

## Building your own custom image

In the previous example we learned about how to make use of existing container images that someone else has made available. In this section you will build a supersimple but still custom webserver.

## Universal base image

We at Red Hat have made a universal base image ```(UBI)``` available for anyone to use freely. ```No subscription required.``` The real good thing with base your container builds on these is that when you run on RHEL they are considered as RHEL and hence the entire stack is ```supported```. This for sure includes when running on ```OpenShift```.

So we use now the buildah tooling, the help function is same as previous tool.
```
buildah --help
buildah <subcommand> --help
```
You can for sure pull images but we will go straight to the point and build a simple container serving a custom page using apache.
```
cat << 'EOF' >Dockerfile
#
# Version 1

# Pull the ubi8 image from Red Hat registry
FROM registry.access.redhat.com/ubi8

# This should be changed
MAINTAINER someone@somewhere.pleasechange

# Add the httpd package to the image 
RUN yum install httpd -y; yum clean all

# Add custom content to default index file
RUN echo "UBI plus buildha says hello" > /var/www/html/index.html

# run the apache webserver
EXPOSE 80
CMD /usr/sbin/httpd -X
EOF
```
And then it is time to build
```
buildah build-using-dockerfile --tag mylocalubi
```
Then run your newly created container image:
```
podman run -dt -p 8080:80/tcp localhost/mylocalubi
```
Also remeber to stop and remove this latest container
```
podman stop -l
podman rm -l
```

## Setting your container to start at boot

As these tools are just tools not a deamon we need to create a systemd definition to use with the container(s) that we want to run at boot. As a serice if you like

We are using the same container as above but will add a name that is known:

```
podman run -dt --name myubi -p 8080:80/tcp localhost/mylocalubi
```

:exclamation: Notice the ```--name myubi```

As this container now is named, use the podman ps to see:
```
podman ps

CONTAINER ID     IMAGE        COMMAND      ...   NAMES
59b4d3f7...      mylocalubi   httpd -X     ...   myubi
```
:exclamation: The above output is abbreviated you might need to enlarge your terminal to see it correctly.

So now we have a container running that has a name we can use. So now lets create the needed systemd definition.

```
podman generate systemd --name myubi
```
Will generate this output

```
# container-myubi.service
# autogenerated by Podman 2.0.5
# Mon Jan  4 10:59:05 CET 2021

[Unit]
Description=Podman container-myubi.service
Documentation=man:podman-generate-systemd(1)
Wants=network.target
After=network-online.target

[Service]
Environment=PODMAN_SYSTEMD_UNIT=%n
Restart=on-failure
ExecStart=/usr/bin/podman start myubi
ExecStop=/usr/bin/podman stop -t 10 myubi
ExecStopPost=/usr/bin/podman stop -t 10 myubi
PIDFile=/run/user/1000/containers/overlay-containers/59b4d3f7e33a3689096ec97f6378ddc1fef4db38d56159dee05ab65fbba50bc5/userdata/conmon.pid
KillMode=none
Type=forking

[Install]
WantedBy=multi-user.target default.target
```

Copy and place here:
```
~/.config/systemd/user/myubi.service
```

You might need to create the folder first, use this command:
```
mkdir -p ~/.config/systemd/user
```

Notify the daemon that there is a new service definition using this command:
```
systemctl --user daemon-reload
```

And active with this command
```
systemctl --user start myubi.service
```

Now this container will be running also after reboot as your user, ```not as root!```

## Migration from localhost to kubernetes

As most peoples today are moving from a single host local setup to using kubernetes for container orchestration there is some help in podman to ease this move.

We will reuse the container from above with a different name:
```
podman run -dt --name movetok8s -p 8080:80/tcp localhost/mylocalubi
```
:exclamation: Notice the ```--name movetok8s```

Now this container is also running, lets check using podman ps
```
podman ps

CONTAINER ID     IMAGE        COMMAND      ...   NAMES
59b4d3f7...      mylocalubi   httpd -X     ...   movetok8s
```
:exclamation: The above output is abbreviated you might need to enlarge your terminal to see it correctly.

So now lets generate the kubernetes yaml.
```
podman generate kube movetok8s # > nameof.yaml
```

Which outputs yaml, abbreviated lots.

```
# Generation of Kubernetes YAML is still under development!
#
# Save the output of this file and use kubectl create -f to import
# it into Kubernetes.
#
# Created with podman-2.0.5
apiVersion: v1
kind: Pod
...
```

Now in order to use this we need a kubernetes cluster and access.
```
kubectl create -f nameof.yaml
pod/movetok8s-libpod created
service/movetok8s-libpod created
```

And thats it...

Continue to [assignment 6](assign6.md)

Back to [index](thews.md)

