Mac OSX build instructions  
==========================

*Laszlo Hanyecz <solar@heliacal.net>  
Douglas Huff <dhuff@jrbobdobbs.org>*


See [readme-qt.md](readme-qt.md) for instructions on building Growers QT, the
graphical user interface.

Tested on 10.5 and 10.6 intel. PPC is not supported because it's big-endian.

All of the commands should be executed in `Terminal.app`. it's in
`/Applications/Utilities`

You need to install XCode with all the options checked so that the compiler and
everything is available in `/usr` not just `/Developer`. I think it comes on the DVD
but you can get the current version from http://developer.apple.com


1.  Clone the github tree to get the source code:

    ```sh
    git clone git@github.com:redpoint404/growers.git growers
    ```

2.  Download and install MacPorts from http://www.macports.org/  
    For 10.7 (Lion):  
    Edit `/opt/local/etc/macports/macports.conf` and uncomment `build_arch i386`

3.  Install dependencies from MacPorts

    ```sh
    sudo port install boost db48 openssl miniupnpc
    ```

    Optionally install qrencode (and set USE_QRCODE=1):
    
    ```sh
    sudo port install qrencode
    ```

4.  Now you should be able to build growersd:

    ```sh
    cd growers/src
    make -f makefile.osx
    ```

For a list of command-line options, run:
```sh
./growersd --help
```

To start the growers daemon, run:

```sh
./growersd -daemon
```

When the daemon is running, get a list of RPC commands with:

```sh
./growersd help
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
