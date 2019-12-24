GrowersCoin desktop wallet
==========================

Build instructions
===================

*The instructions here help you building the GrowersCoin Qt4 desktop wallet binary.*

Debian/Ubuntu
-------------

First, make sure that the required packages for Qt5 development of your
distribution are installed, for Debian and Ubuntu these are:

```sh
sudo apt-get install build-essential libssl-dev libdb++-dev libboost-all-dev libminiupnpc-dev qt4-default
```

You'll need to download the `libqrcode` package and build it enabling the static mode or the wallet wont compile:

```sh
sudo su
cd /usr/src
apt-get install -y autoconf automake autotools-dev libtool pkg-config libpng12-dev
wget https://fukuchi.org/works/qrencode/qrencode-4.0.2.tar.gz
tar zxvf qrencode-4.0.2.tar.gz
cd qrencode-4.0.2
./configure --enable-static
make
make install
ldconfig
exit
```

Then execute the following:

```
qmake growers-qt.pro USE_UPNP=1 USE_QRCODE=1 RELEASE=1
make
strip growers-qt
```

An executable named `growers-qt` will be built.


Windows
--------

GrowersCoin releases are cross-compiled on an **Ubuntu Linux 16 server** using the **M Cross Environment** (also
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

8. (Optional) Build QRencode library:

   ```sh
   cd /mnt/mxe
   make MXE_TARGETS="i686-w64-mingw32.static" libqrencode
   ```

9. Build QT:

   ```sh
   cd /mnt/mxe
   make MXE_TARGETS="i686-w64-mingw32.static" qt
   ```
   
   Note: this will take 3-4 hours or more, depending on your machine speed.

10. Downgrade OpenSSL to 1.0:

    ```sh
    cd /mnt/mxe
    make openssl1.0 MXE_TARGETS="i686-w64-mingw32.static" MXE_PLUGIN_DIRS=plugins/examples/openssl1.0/
    ```
   
    This step is important because OpenSSL 1.1 causes an issue that prevents the wallet from compiling.
   
11. Build LevelDB:

    ```sh
    cd /mnt/growers/src/leveldb
    TARGET_OS=OS_WINDOWS_CROSSCOMPILE CC=/mnt/mxe/usr/bin/i686-w64-mingw32.static-gcc \
        CXX=/mnt/mxe/usr/bin/i686-w64-mingw32.static-g++ make libleveldb.a libmemenv.a
    cd /mnt/growers
    ```

12. Do this **once**:

    To avoid the compilation breaking with the next error:
    
    ```
    mnt/mxe/usr/i686-w64-mingw32.static/include/boost/type_traits/detail/has_binary_operator.hp:50: Parse error at "BOOST_JOIN"
    Makefile.Release:810: recipe for target 'build/rpcconsole.moc' failed
    make: *** [build/rpcconsole.moc] Error 1
    ```
    
    You will need to edit the `has_binary_operator.hpp` file by running:
    
    ```sh
    nano /mnt/mxe/usr/i686-w64-mingw32.static/include/boost/type_traits/detail/has_binary_operator.hpp
    ```
    
    Once opened, add this line **at the top of the file**:
    
    ```cpp
    #ifndef Q_MOC_RUN
    ```
    
    Then go **to the end of the file** and add this line:
    
    ```cpp
    #endif
    ```
    
    Press `Ctrl-X`, save and exit, then try rebuilding again. It should go fine.

13. Build GrowersCoin:
    
    By default, UPNP and QRCODE are included in the building script, which can be edited with `nano`:
    
    ```sh
    nano /mnt/growers/mxe-build-growers-qt.sh
    ```
        
    * If you **do not want** QRCODE, go to line 14 and change `USE_QRCODE=1` to `USE_QRCODE=0`
    * If you **do not want** UPNP, go to line 15 and change `USE_UPNP=1` to `USE_UPNP=-`
    
    Once you make those changes, press `Ctrl-X` to save and exit.
    
    **Now compile the wallet:**
    
    ```sh
    cd /mnt/growers
    ./mxe-build-growers-qt.sh
    ```
   
If no errors are found, you can find the `growers-qt.exe` file on `/mnt/growers/release`,
and you can get it in your Windows desktop with a file transfer utility like [WinSCP](https://winscp.net/).

Mac OS X
--------

Building the QT wallet on a Mac will be really tricky, so pay atention.

1. First of all, go to the [OSX build instructions](build-osx.md) and take all steps except the final one
   (actually building the `growersd` file).
   
   Once you've compiled leveldb, type the next lines on the command window:
   
   ```sh
   BUILDING_DIR=$HOME/Devel/build
   cd $HOME/Devel/growers
   ```
   
2. On the terminal window, install Qt4 using Macports:

   ```sh
   sudo port install qt4-mac
   ```
   
   Let's make a copy of the libraries, we'll need them later:
   
   ```sh
   sudo mkdir /opt/local/Library/Frameworks
   sudo cp -R /opt/local/libexec/qt4/Library/Frameworks/* /opt/local/Library/Frameworks
   ```

3. Do this **once**:
   
   To avoid the compilation breaking with the next error:
   
   ```
   /Users/YOUR_USERNAME/Devel/build/include/boost/type_traits/detail/has_binary_operator.hp:50: Parse error at "BOOST_JOIN"
   make: *** [build/rpcconsole.moc] Error 1
   ```
   
   You will need to edit the `has_binary_operator.hpp` file by running:
   
   ```sh
   nano /mnt/mxe/usr/i686-w64-mingw32.static/include/boost/type_traits/detail/has_binary_operator.hpp
   ```
   
   Once opened, add this line **at the top of the file**:
   
   ```cpp
   #ifndef Q_MOC_RUN
   ```
   
   Then go **to the end of the file** and add this line:
   
   ```cpp
   #endif
   ```
   
   Press `Ctrl-X`, save and exit.
   
4. Edit the `growers-mac.pro` file:

   The template for building the wallet needs to be edited before compiling the wallet.
   You need to specify the building directory. First, launch this on the terminal:
   
   ```sh
   cd $HOME/Devel/growers
   nano growers-mac.pro
   ```

   Around line 17, you'll see the next:
    
   ```sh
    #######################################
    # WARNING: EDIT THIS BEFORE LAUNCHING #
    ##############################################
    BUILDING_DIR=/Users/YOUR_USER_NAME/Devel/build
    ##############################################
   ```
    
    You need to change `YOUR_USER_NAME` to your actual folder user name, E.G. in `/Users/John_Doe`,
    the folder will be `John_Doe`. The segment should end like this:
    
   ```sh
    #######################################
    # WARNING: EDIT THIS BEFORE LAUNCHING #
    ##############################################
    BUILDING_DIR=/Users/John_Doe/Devel/build
    ##############################################
   ```
   
   Press `Ctrl-X`, save and exit.

   > Note: this step is necessary because, at the time of writing this document, the path couldn't be passed
   > over the command line. Qmake was ignoring it blatantly.
   
5. Compile the wallet:
   
   If you want UPNP support:
   
   ```sh
   cd $HOME/Devel/GrowersCoin
   /opt/local/libexec/qt4/bin/qmake \
       USE_UPNP=1 RELEASE=1 \
       QMAKE_LRELEASE=/opt/local/libexec/qt4/bin/lrelease \
           growers-mac.pro
   ```
   
   Else:
   
   ```sh
   cd $HOME/Devel/GrowersCoin /opt/local/libexec/qt4/bin/qmake \
       "USE_UPNP=-" RELEASE=1 \
       QMAKE_LRELEASE=/opt/local/libexec/qt4/bin/lrelease \
           growers-mac.pro
   ```
   
   Once the compilation ends, you'll find the `Growers-Qt.app` directory.
   
6. Add dependencies
   
   > On Linux and Windows, the wallets are compiled statically. This means that all dependencies
   > are encapsulated in a single file, so no external stuff is needed to run the binary.
   > Apple doesn't support that. Libraries must be included in the package. Luckily, a MacOS "app" is
   > actually a directory with a defined structure.
   
   First, create some folders and some requirements:
   
   ```sh
   cd $HOME/Devel/GrowersCoin/Growers-Qt.app/Contents
   mkdir Frameworks PlugIns
   
   cd $HOME/Devel/GrowersCoin/Growers-Qt.app/Contents/Frameworks/
   cp /opt/local/lib/db48/libdb_cxx-4.8.dylib ./
   ```
   
   Use the `macdeployqt` utility to have Qt copying and adjusting
   the needs of its dependencies:
   
   ```sh
   cd $HOME/Devel/GrowersCoin/
   /opt/local/libexec/qt4/bin/macdeployqt Growers-Qt.app
   cd $HOME/Devel/GrowersCoin/Growers-Qt.app/Contents/Frameworks/
   ```
   
   Now, using `install_name_tool`, adjust the path of the db library:
   
   ```sh
   cd $HOME/Devel/GrowersCoin/Growers-Qt.app/Contents/MacOS
   install_name_tool -change /opt/local/lib/db48/libdb_cxx-4.8.dylib \
        @executable_path/../Frameworks/libdb_cxx-4.8.dylib \
        Growers-Qt
   ```
   
   The rest of the libraries should be already prepared by `macdeployqt`.
   For more information about this topic, please check the
   [Fixing library paths on OSX](howto-fix-osx-library-paths.md) document.
   
7. That's all. Now you need to open a Finder window and go to `Devel/GrowersCoin` and move the `Growers-Qt` to
   your Home's `Applications` folder to test it.
   
   If you double click on the Growers-Qt app and you get an error, please check the
   [Fixing library paths on OSX](howto-fix-osx-library-paths.md) document.
   
   If everything goes fine, you might want to package your app into a DMG.
   [Check this guide](https://www.wikihow.com/Make-a-DMG-File-on-a-Mac) to learn how to do it.
   

Build configuration options
============================

UPNnP port forwarding
---------------------

To use UPnP for port forwarding behind a NAT router (recommended, as more connections overall allow for a faster and more stable growers experience), pass the following argument to qmake:

```sh
qmake "USE_UPNP=1"
```

This requires miniupnpc for UPnP port mapping.  It can be downloaded from
http://miniupnp.tuxfamily.org/files/.  UPnP support is not compiled in by default.

Set USE_UPNP to a different value to control this:

```
+------------+--------------------------------------------------------------------------+
| USE_UPNP=- | no UPnP support, miniupnpc not required;                                 |
+------------+--------------------------------------------------------------------------+
| USE_UPNP=0 | (the default) built with UPnP, support turned off by default at runtime; |
+------------+--------------------------------------------------------------------------+
| USE_UPNP=1 | build with UPnP support turned on by default at runtime.                 |
+------------+--------------------------------------------------------------------------+
```

Notification support for recent (k)ubuntu versions
---------------------------------------------------

To see desktop notifications on (k)ubuntu versions starting from 10.04, enable usage of the
FreeDesktop notification interface through DBUS using the following qmake option:

```sh
qmake "USE_DBUS=1"
```

Generation of QR codes
-----------------------

**Note:** this feature is currently unsupported on Mac.

`libqrencode` may be used to generate QRCode images for payment requests. 
It can be downloaded from http://fukuchi.org/works/qrencode/index.html.en or installed via your package manager.
Pass the `USE_QRCODE` flag to qmake to control this:

```
+--------------+--------------------------------------------------------------------------+
| USE_QRCODE=0 | (the default) No QRCode support - libarcode not required                 |
+--------------+--------------------------------------------------------------------------+
| USE_QRCODE=1 | QRCode support enabled                                                   |
+--------------+--------------------------------------------------------------------------+
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


Ubuntu 11.10 warning
====================

Ubuntu 11.10 has a package called 'qt-at-spi' installed by default.  At the time of writing, having that package
installed causes growers-qt to crash intermittently.  The issue has been reported as
[launchpad bug 857790](https://bugs.launchpad.net/ubuntu/+source/qt-at-spi/+bug/857790).

If this bug hits you, you can remove the `qt-at-spi` package to work around the problem, though this will presumably
disable screen reader functionality for Qt apps:

```sh
sudo apt-get remove qt-at-spi
```
