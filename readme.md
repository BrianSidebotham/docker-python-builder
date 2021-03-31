# Python Builder

Various containers to build Python from source. All of the necessary build dependencies are installed.

An example of using this container to build a CentOS7 Python RPM:

```console
$ docker run -v $(pwd):/build bsidebotham/python-builder:centos7
...

$ ls -l ./RPMS/x86_64/
-rw-r--r--. 1 root root 32229524 Mar 31 16:08 python39-3.9.2-1.el7.x86_64.rpm
```

You can go ahead and build other versions too using the `PYTHONVERSION` environment variable:

```console
$ docker run -e PYTHONVERSION=3.8.8 -v $(pwd):/build bsidebotham/python-builder:centos7
...

$ ls -l ./RPMS/x86_64/
-rw-r--r--. 1 root root 31839876 Mar 31 17:00 python38-3.8.8-1.el7.x86_64.rpm
-rw-r--r--. 1 root root 32228720 Mar 31 16:55 python39-3.9.2-1.el7.x86_64.rpm
```

## ENVIRONMENT VARIABLES

- `PYTHONVERSION` The verison of Python to build and package

