
GrowersCoin (Growers, GRWI)
===========================

![GrowersCoin](doc/growerscoin_logo_256x256.png)


What is GrowersCoin?
--------------------

GrowersCoin or just "Growers" is digital currency for cannabis growers.
It is specifically designed to benefit legal cultivators and merchants around the world through a blockchain enabled
software suite made by [Growers International](https://grwi.io/about) built by professional growers and
cryptocurrency experts with the goal of helping fellow growers succeed.

We are swiftly reaching the end of cannabis prohibition and the beginning of global
legalization, and tools like GrowersCoin will help usher in the future of the cannabis industry.

[► Learn more](https://grwi.io/about).

License
-------

GrowersCoin is released under the terms of the MIT/X11 license.  
See [COPYING](COPYING) for more information or see http://www.opensource.org/licenses/mit-license.php

Changes
-------

Please check the [Changelog](CHANGELOG.md) for full information.

Coin specifications
-------------------

* Algorithm: Scrypt
* Network: POW, POS
* Symbol: GRWI
* Supply: 1,220,217 GRWI
* Staking: 8 hours min age, 5% annual rate
* Default P2P port: 11667
* Default RPC port: 12667

Prebuilt binaries for Linux, Windows and Mac OSX
------------------------------------------------

Please visit the [GrowersCoin wallets download page](https://grwi.io/wallet) for links and notes.

Building the wallet
-------------------

The following are developer notes on how to build GrowersCoin on your native platform.
They are not complete guides, but include notes on the necessary libraries, compile flags, etc.

### Daemon binary (headless client, for service-centric nodes):
* [Unix Build Notes](doc/build-unix.md)
* [Windows Build Notes](doc/build-msw.md)
* [OSX Build Notes](doc/build-osx.md)

### Desktop wallet (with user interface):
* [Unix Build Notes](doc/readme-qt-unix.md)
* [Windows Build Notes](doc/readme-qt-win.md)
* [OSX Build Notes](doc/readme-qt-osx.md)

Development process
-------------------

Developers work in their own trees, then submit pull requests when
they think their feature or bug fix is ready.

The patch will be accepted if there is broad consensus that it is a
good thing.  Developers should expect to rework and resubmit patches
if they don't match the project's coding conventions
(see [doc/coding.txt](doc/coding.txt)) or are controversial.

The master branch is regularly built and tested, but is not guaranteed
to be completely stable. Tags are regularly created to indicate new
stable release versions of Growers.

Feature branches are created when there are major new features being
worked on by several people.

From time to time a pull request will become outdated. If this occurs, and
the pull is no longer automatically mergeable; a comment on the pull will
be used to issue a warning of closure. The pull will be closed 15 days
after the warning if action is not taken by the author. Pull requests closed
in this manner will have their corresponding issue labeled 'stagnant'.

Issues with no commits will be given a similar warning, and closed after
15 days from their last activity. Issues closed in this manner will be 
labeled 'stale'.
