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

The second tool is buildah, as the name in a sense implies it is the tool for building your own container-images.

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

:exclamation: Please note the double ```>>``` on the last line there.


Back to [index](thews.md)

