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
$ podman --help
$ podman <subcommand> --help
```
For more details, you can review the manpages:
```
$ man podman
$ man podman-<subcommand>
```
Please also reference the Podman Troubleshooting Guide to find known issues and tips on how to solve common configuration mistakes.

## Searching, pulling & listing images
Podman can search for images on remote registries with some simple keywords.
```
$ podman search <search_term>
```
You can also enhance your search with filters:
```
$ podman search httpd --filter=is-official
```
Downloading (Pulling) an image is easy, too.
```
$ podman pull registry.fedoraproject.org/f29/httpd
```
After pulling some images, you can list all images, present on your machine.
```
$ podman images
```
:exclamation: Podman searches in different registries. Therefore it is recommend to use the full image name (registry.fedoraproject.org/f29/httpd instead of httpd) to ensure, that you are using the correct image.

## Running a container
This sample container will run a very basic httpd server that serves only its index page.
```
$ podman run -dt -p 8080:8080/tcp registry.fedoraproject.org/f29/httpd
```
:exclamation: Because the container is being run in detached mode, represented by the -d in the podman run command, Podman will print the container ID after it has executed the command. The -t also adds a pseudo-tty to run arbitrary commands in an interactive shell.

:exclamation: We use port forwarding to be able to access the HTTP server. For successful running at least slirp4netns v0.3.0 is needed.

## Listing running containers
The podman ps command is used to list created and running containers.
```
$ podman ps
```
:exclamation: If you add -a to the podman ps command, Podman will show all containers (created, exited, running, etc.).

## Testing the httpd container
As you are able to see, the container does not have an IP Address assigned. The container is reachable via it’s published port on your local machine.
```
$ curl http://localhost:8080
```
From another machine, you need to use the IP Address of the host, running the container.
```
$ curl http://<IP_Address>:8080
```
:exclamation: Instead of using curl, you can also point a browser to http://localhost:8080.

## Inspecting a running container
You can “inspect” a running container for metadata and details about itself. podman inspect will provide lots of useful information like environment variables, network settings or allocated resources.

Since, the container is running in rootless mode, no IP Address is assigned to the container.
```
$ podman inspect -l | grep IPAddress
            "IPAddress": "",
```
:exclamation: The -l is a convenience argument for latest container. You can also use the container’s ID or name instead of -l or the long argument --latest.

## Viewing the container’s logs
You can view the container’s logs with Podman as well:
```
$ podman logs -l

127.0.0.1 - - [04/May/2020:08:33:48 +0000] "GET / HTTP/1.1" 200 45
127.0.0.1 - - [04/May/2020:08:33:50 +0000] "GET / HTTP/1.1" 200 45
127.0.0.1 - - [04/May/2020:08:33:51 +0000] "GET / HTTP/1.1" 200 45
127.0.0.1 - - [04/May/2020:08:33:51 +0000] "GET / HTTP/1.1" 200 45
127.0.0.1 - - [04/May/2020:08:33:52 +0000] "GET / HTTP/1.1" 200 45
127.0.0.1 - - [04/May/2020:08:33:52 +0000] "GET / HTTP/1.1" 200 45
```

## Viewing the container’s pids
You can observe the httpd pid in the container with podman top.
```
$ podman top -l

USER     PID   PPID   %CPU    ELAPSED            TTY     TIME   COMMAND
root     1     0      0.000   22m13.33281018s    pts/0   0s     httpd -DFOREGROUND
daemon   3     1      0.000   22m13.333132179s   pts/0   0s     httpd -DFOREGROUND
daemon   4     1      0.000   22m13.333276305s   pts/0   0s     httpd -DFOREGROUND
daemon   5     1      0.000   22m13.333818476s   pts/0   0s     httpd -DFOREGROUND
```
## Stopping the container
You may stop the container:
```
$ podman stop -l
```
You can check the status of one or more containers using the podman ps command. In this case, you should use the -a argument to list all containers.
```
$ podman ps -a
```
## Removing the container
Finally, you can remove the container:
```
$ podman rm -l
```
You can verify the deletion of the container by running podman ps -a.


Back to [index](thews.md)

