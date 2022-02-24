# Python Builder

Various containers to build Python from source. All of the necessary build dependencies are installed.

Build times are significantly quicker with Python >= 3.8.

An example of using these containers to build a CentOS7 Python RPM:

```console
$ docker run -v $(pwd):/build ghcr.io/briansidebotham/docker-python-builder:centos8
...

$ ls -l ./RPMS/x86_64/
-rw-r--r--. 1 root root 32229524 Mar 31 16:08 python39-3.9.2-1.el7.x86_64.rpm
```

You can go ahead and build other versions too using the `PYTHONVERSION` environment variable:

```console
$ docker run -e PYTHONVERSION=3.8.8 -v $(pwd):/build ghcr.io/briansidebotham/docker-python-builder:centos8
...

$ ls -l ./RPMS/x86_64/
-rw-r--r--. 1 root root 31839876 Mar 31 17:00 python38-3.8.8-1.el7.x86_64.rpm
-rw-r--r--. 1 root root 32228720 Mar 31 16:55 python39-3.9.2-1.el7.x86_64.rpm
```
> **NOTE:** You can only do multiple builds in the same volume if you're doing different python
> versions for the same OS. If you try to build for a different OS in the same volume you are
> likely to get (possibly subtle!) issues.

If you're looking for a container with a specific version of Python on head over to the [docker-python](https://github.com/BrianSidebotham/docker-python) project. The [docker-python-builder releases](https://github.com/BrianSidebotham/docker-python-builder/releases) are used to build another set of containers for just that purpose.

## ENVIRONMENT VARIABLES

- `PYTHONVERSION` The verison of Python to build and package

