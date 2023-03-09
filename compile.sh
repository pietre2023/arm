#!/bin/bash
sudo apt install swig python-dev gcc-arm-linux-gnueabihf bison flex make python3-setuptools libssl-dev
make CROSS_COMPILE=aarch64-linux-gnu-
