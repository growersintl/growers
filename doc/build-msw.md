
Windows build instructions
==========================

*These instructions are to build the GrowersCoin headless executable.
If you want to build the graphical user interface,
see [readme-qt.md](readme-qt.md) for instructions on building
the Qt desktop wallet.*


GrowersCoin releases are cross-compiled on an **Ubuntu Linux 16** server using the **M Cross Environment** (also
known as **[MXE](https://mxe.cc/)**). Following these steps you can build your wallet in a few hours.

> We strongly recommend you to build an Ubuntu 16 Server on VirtualBox or VMWare Player.  
> Give it at least two cores, 4 GB of RAM and 20 GB on disk. 4GB RAM and 4 cores work better.

1. Login into the VM and become root:

    ```
   sudo -i
   ```

2. Download all requirements:
    
    ```sh
    apt-get install -y p7zip-full autoconf automake autopoint bash bison bzip2 cmake flex gettext git g++ gperf
    apt-get install -y intltool libffi-dev libtool libltdl-dev libssl-dev libxml-parser-perl make openssl patch
    apt-get install -y perl pkg-config python ruby scons sed unzip wget xz-utils lzip
    apt-get install -y g++-multilib libc6-dev-i386
    apt-get install -y libtool libtool-bin
    apt-get install -y libgtk2.0-dev
    ```

3. Clone the MXE repository into `/mnt`:
    
   ```sh
   cd /mnt
   git clone https://github.com/mxe/mxe.git
   ```
4. Clone the GrowersCoin repository. It comes with some scripts that will help compiling some of the packages:
    
   ```sh
   cd /mnt
   git clone https://github.com/growersintl/growers.git
   ```

5. Download and build Boost:

   ```sh
   cd /mnt/mxe
   make MXE_TARGETS="i686-w64-mingw32.static" boost
   ```
    **Note**: this will take a couple of hours or more, depending on your machine speed.

6. Build Berkeley DB:

   ```sh
   cd /mnt
   wget http://download.oracle.com/berkeley-db/db-5.3.28.tar.gz
   tar zxvf db-5.3.28.tar.gz
   cd db-5.3.28
   ../growers/mxe-build-db.sh
   cd ..
   ```

7. (Optional) Build Mini UPNP client:

   ```sh
   cd /mnt
   wget http://miniupnp.free.fr/files/miniupnpc-1.6.20120509.tar.gz
   tar zxvf miniupnpc-1.6.20120509.tar.gz
   cd miniupnpc-1.6.20120509
   ../growers/mxe-build-upnp.sh
   cd ..
   ```

8. Downgrade OpenSSL to 1.0:

   ```sh
   cd /mnt/mxe
   make openssl1.0 MXE_TARGETS="i686-w64-mingw32.static" MXE_PLUGIN_DIRS=plugins/examples/openssl1.0/
   ```
   
   This step is important because OpenSSL 1.1 causes an issue that prevents the wallet from compiling.

9. Build LevelDB:

   ```sh
   cd /mnt/growers/src/leveldb
   TARGET_OS=OS_WINDOWS_CROSSCOMPILE CC=/mnt/mxe/usr/bin/i686-w64-mingw32.static-gcc \
       CXX=/mnt/mxe/usr/bin/i686-w64-mingw32.static-g++ make libleveldb.a libmemenv.a
   cd /mnt/growers
   ```

10. Build the daemon:

    By default, UPNP is disabled. If you want to enable it, run:
    
    ```sh
    make -f makefile.linux-mingw USE_UPNP=1
    ```
    
    Otherwise, run:
    
    ```sh
    make -f makefile.linux-mingw
    ```
    
    Once built, strip debug symbols:
    
    ```sh
    strip growersd
    ```

You just need to move the `growersd` file to either `/usr/local/bin`,
`/usr/bin` or any other path you want to run it from.

For a list of command-line options, run:
```sh
growersd --help
```

To start the growers daemon, run:

```sh
growersd -daemon
```

When the daemon is running, get a list of RPC commands with:

```sh
growersd help
```

Build configuration options
============================

UPNnP port forwarding
---------------------

To use UPnP for port forwarding behind a NAT router is turned off by default.
It is recommended only for desktop computers and not neccessary for servers.
If you want to enable it, pass the following argument to make:

```sh
make -f makefile.linux-mingw USE_UPNP=1
```

Set `USE_UPNP` to a different value to control this:

```
+------------+-------------------------------------------------------------+
| USE_UPNP=- | no UPnP support, miniupnpc not required (the default);      |
+------------+-------------------------------------------------------------+
| USE_UPNP=0 | built with UPnP, support turned off by default at runtime;  |
+------------+-------------------------------------------------------------+
| USE_UPNP=1 | build with UPnP support turned on by default at runtime.    |
+------------+-------------------------------------------------------------+
```


Berkely DB version warning
==========================

A warning for people using the *static binary* version of Growers on a Linux/UNIX-ish system
(tl;dr: **Berkely DB databases are not forward compatible**).

The static binary version of Growers is linked against libdb 5.0
(see also [this Debian issue](http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=621425)).

Now the nasty thing is that databases from 5.X are not compatible with 4.X.

If the globally installed development package of Berkely DB installed on your system is 5.X, any source you
build yourself will be linked against that. The first time you run with a 5.X version the database will be upgraded,
and 4.X cannot open the new format. This means that you cannot go back to the old statically linked version without
significant hassle!


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
