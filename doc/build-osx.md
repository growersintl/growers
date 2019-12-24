Mac OSX build instructions  
==========================

*These instructions are to build the GrowersCoin headless executable.
If you want to build the graphical user interface,
see [readme-qt-osx.md](readme-qt-osx.md) for instructions on building
the Qt desktop wallet.*

The commands in this guide should be executed in a Terminal application.
You just need to open the launchpad and type "term", then click on the icon.

Note: You're going to need Xcode, and to get Xcode you'll need to register as an Apple Developer
and pay a fee. But there's a way to get a free license, just follow the steps on this article:
https://ww.9to5mac.com/2016/03/27/how-to-create-free-apple-developer-account-sideload-apps/

> **Important:** Apple removed support for 32 bit applications on macOS 10.15 (Catalina).
> These steps will guide you to build growersd for 64 bits architecture, which will make
> it compatible with Catalina.

Preparation
-----------

1.  Install Xcode.

2.  Open a Terminal window and install the macOS command line tools:

    ```sh
    xcode-select --install
    ```

    When the popup appears, click Install.

3.  Download and install MacPorts from http://www.macports.org/  
    
4.  Install BerkeleyDB with MacPorts:

    ```sh
    sudo port db48
    ```
    
5.  Download dependencies:
   
    * OpenSSL 1.0.2u from http://www.openssl.org/source/
    * Boost 1.58.0 from http://www.boost.org/users/download/
    * (Optional) MiniUPNPc 1.9.20140610 from http://miniupnp.tuxfamily.org/files/
   
    Create a folder called `Devel` on your home folder, then move the downloaded files
    from your downloads folder here.
   
6.  Open a terminal window and extract the packages:
     
    ```sh
    cd Devel
    mkdir build
    BUILDING_DIR=$HOME/Devel/build
    tar -zxvf openssl-1.0.2u.tar.gz
    tar -zxvf boost_1_58_0.tar.gz
    ```

7.  Build OpenSSL:

    ```sh
    cd $HOME/Devel/openssl-1.0.2u
    ./Configure darwin64-x86_64-cc --prefix=$BUILDING_DIR
    make
    ```

8.  Build Boost:

    ```sh
    cd $HOME/Devel/boost_1_58_0
    ./bootstrap.sh
    ./b2 --prefix=$BUILDING_DIR \
         link=static threading=multi runtime-link=static variant=release \
         install
    ```

9.  (optional) Build MiniUPNPc:

    ```sh
    cd $HOME/Devel
    tar -zxvf miniupnpc-1.9.20140610.tar.gz
    cd miniupnpc-1.9.20140610
    make
    cp libminiupnpc.a $BUILDING_DIR/lib
    mkdir $BUILDING_DIR/include/miniupnpc
    cp *.h $BUILDING_DIR/include/miniupnpc
    ```

10. Clone the GrowersCoin git repository:

    ```sh
    cd $HOME/Devel
    git clone https://github.com/growersintl/growers.git
    ```

11. Build LevelDB:
    
    ```sh
    cd $HOME/Devel/growers/src/leveldb
    make libleveldb.a libmemenv.a
    ```

12. Now you should be able to build `growersd`:
    
    If you compiled MiniUPNPc:
    
    ```sh
    cd cd $HOME/Devel/growers/src
    make -f makefile.osx USE_UPNP=1 STATIC=1
    strip growersd
    ```
    
    Else:
    
    ```sh
    cd cd $HOME/Devel/growers/src
    make -f makefile.osx "USE_UPNP=-" STATIC=1
    strip growersd
    ```

After a successful compilation, you should move the `growersd` binary to another location
in your home folder.

Using the daemon
================

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
