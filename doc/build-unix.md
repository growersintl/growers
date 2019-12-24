Unix build notes
================

*These instructions are to build the GrowersCoin headless executable.
If you want to build the graphical user interface,
see [readme-qt-unix.md](readme-qt-unix.md) for instructions on building
the Qt desktop wallet.*

> We strongly recommend you to build an Ubuntu 16 Server on VirtualBox or VMWare Player.  
> Give it at least two cores, 4 GB of RAM and 20 GB on disk. 4GB RAM and 4 cores work better.


Dependencies
============

```
Library     Purpose           Description
-------     -------           -----------
libssl      SSL Support       Secure communications
libdb       Berkeley DB       Blockchain & wallet storage
libboost    Boost             C++ Library
miniupnpc   UPnP Support      Optional firewall-jumping support
```
    
Licenses of statically linked libraries:

```
Berkeley DB   New BSD license with additional requirement that linked
              software must be free open source
Boost         MIT-like license
miniupnpc     New (3-clause) BSD license
```

The current GrowersCoin release was built on an **Ubuntu 16 server** using the next package versions:

```
 GCC           5.4.0
 OpenSSL       1.0.2g
 Berkeley DB   5.3.21
 Boost         1.58.0
 miniupnpc     1.9.20140610
```

The `growersd` binary has been built **static** so it can be used on any OS that has
GLIBC 2.26 or better.

Dependency Build Instructions: Ubuntu & Debian
----------------------------------------------

```sh
sudo apt-get install build-essential libssl-dev libdb++-dev libboost-all-dev libminiupnpc-dev
```

Build the GrowersCoin daemon
----------------------------

**Note:** `miniupnpc` may be used for UPnP port mapping.  It can be downloaded from
http://miniupnp.tuxfamily.org/files/.  UPnP support is compiled in and
turned off by default.  Set `USE_UPNP` to a different value to control this:

To build without UPnP support (default), just build without parameters:

```sh
make -f makefile.unix
```

To build with UPnP disabled by default:

```sh
make -f makefile.unix USE_UPNP=0
```

To build with UPnP enabled by default:

```sh
make -f makefile.unix USE_UPNP=1
```

Note: If you want to make a static binary (no requirements) add `STATIC=1` to the `make` command.

Once the compilation ends, strip the file:

```sh
strip growersd
```


Security notes
--------------

To help make your growers installation more secure by making certain attacks impossible to
exploit even if a vulnerability is found, you can take the following measures:

* Position Independent Executable

    Build position independent code to take advantage of Address Space Layout Randomization
    offered by some kernels. An attacker who is able to cause execution of code at an arbitrary
    memory location is thwarted if he doesn't know where anything useful is located.
    The stack and heap are randomly located by default but this allows the code section to be
    randomly located as well.

    On an Amd64 processor where a library was not compiled with -fPIC, this will cause an error
    such as: `relocation R_X86_64_32 against '......' can not be used when making a shared object;`

    To build with PIE, use:
    ```sh
    make -f makefile.unix ... -e PIE=1
    ```

    To test that you have built PIE executable, install scanelf, part of paxutils, and use:
    ```sh
    scanelf -e ./growers
    ```
    
    The output should contain:
    ```
     TYPE
    ET_DYN
    ```
  
* Non-executable Stack

    If the stack is executable then trivial stack based buffer overflow exploits are possible if
    vulnerable buffers are found. By default, growers should be built with a non-executable stack
    but if one of the libraries it uses asks for an executable stack or someone makes a mistake
    and uses a compiler extension which requires an executable stack, it will silently build an
    executable without the non-executable stack protection.

    To verify that the stack is non-executable after compiling use:
    
    ```sh
    scanelf -e ./growers
    ```

    the output should contain:
    ```
    GPH/REL/PTL
    RW- R-- RW-
    ```
    
    The `GPH RW-` means that the stack is readable and writeable but not executable.


Copyright information
=====================

Copyright (c) 2009-2012 Bitcoin Developers  
Copyright (c) 2017-2019 GrowersCoin Developers

Distributed under the MIT/X11 software license, see the accompanying file
license.txt or http://www.opensource.org/licenses/mit-license.php.  This
product includes software developed by the OpenSSL Project for use in the
OpenSSL Toolkit (http://www.openssl.org/).  This product includes cryptographic
software written by Eric Young (eay@cryptsoft.com) and UPnP software written by
Thomas Bernard.
