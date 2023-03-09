#!/bin/bash
sudo apt install swig python-dev gcc-arm-linux-gnueabihf bison flex make python3-setuptools libssl-dev u-boot-tools device-tree-compiler
git clone git://git.denx.de/u-boot.git
cd u-boot
make CROSS_COMPILE=aarch64-linux-gnu-
