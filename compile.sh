#!/bin/bash
sudo apt install -y swig python-dev gcc-arm-linux-gnueabihf bison flex make python3-setuptools libssl-dev u-boot-tools device-tree-compiler
git clone git://git.denx.de/u-boot.git
cd u-boot
echo "      Menu de compilación del u-boot para tablets"
echo " Elija una opción para compilación del u-boot según su modelo de tablet"
sleep 2
echo "1. 	Tablet a13 q8 "
echo ""
echo "2. 	Tablet a23 q8 Resolución 800x480"
echo ""
echo "3. 	Tablet a33 q8 Resolución 1024x600"
echo ""
echo "4. 	Tablet a33 q8 Resolución 800x480"
echo ""
echo "5. 	Tablet iNet_3F"
echo ""
echo "6. 	Tablet iNet_3W"
echo ""
echo "7. 	Tableti Net_86VS"
echo ""
echo "8. 	Tablet iNet_D978"
echo ""
echo "9. Tablet inet_1"
echo ""
echo "10. Pinetab"
echo -n "	Seleccione una opcion [1 - 8]"
read uboot
case $uboot in
1) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- q8_a13_tablet_defconfig;;
2) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- q8_a23_tablet_800x480_defconfig;;
3) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- q8_a33_tablet_1024x600_defconfig;;
4) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- q8_a33_tablet_800x480_defconfig;;
5) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- iNet_3F_defconfig ;;
6) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- iNet_3W_defconfig;;
7) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- iNet_86VS_defconfig;;
8) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- iNet_D978_rev2_defconfig;;
9) sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- inet1_defconfig;;
10 sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- pinetab_defconfig;;

*) echo "$opc no es una opcion válida.";
echo "Presiona una tecla para continuar...";
read foo;;
esac
sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
clear
echo "Compilación de u-boot terminada"
sleep 1
cd u-boot/
echo "Para instalar uboot en una micro-SD:"
echo "dd if=u-boot-sunxi-with-spl.bin of=tutarjetasd bs=1024 seek=8"


##kernel legacy##
#echo "kernel" 
#sleep 2
#echo "kernel Sunxi 3.4"
#git clone -b sunxi-3.4 https://github.com/linux-sunxi/linux-sunxi.git sunxi/kernel/3-4/linux-sunxi
