#!/bin/bash
# variables
arm=ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
arm64=ARCH=ARM64 CROSS_COMPILE=aarch64-linux-gnu-
make="sudo make -j$(nproc)"

dependencias() {
apt install -y swig python-dev gcc-arm-linux-gnueabihf bison flex make python3-setuptools libssl-dev u-boot-tools device-tree-compiler
}
clear
general(){
echo "      Que desea hacer hoy "
sleep 1
echo " Elija una opción "
sleep 1
echo "1.        Instalar dependencias RECOMENDADO "
echo""
echo "2.        Compilar u-boot "
echo ""
echo "3.        Compilar kernel"
echo ""
echo "4.        Crear rootFS"
echo ""
read menu
case $menu in
        1) dependencias;;
        2) uboot;;
        3) kernel;;
        *) echo "$opc no es una opcion válida.";
echo "Presiona una tecla para continuar...";
read foo;
esac
}
clear
uboot(){
        git clone git://git.denx.de/u-boot.git
        clear
        echo "Menu de compilación del u-boot para tablets"
        echo "Elija una opción para compilación del u-boot según su modelo de tablet"
        sleep 2
        echo "1.        Tablet a13 q8 "
        echo ""
        echo "2.        Tablet a23 q8 Resolución 800x480"
        echo ""
        echo "3.        Tablet a33 q8 Resolución 1024x600"
        echo ""
        echo "4.        Tablet a33 q8 Resolución 800x480"
        echo ""
        echo "5.        Tablet iNet_3F"
        echo ""
        echo "6.        Tablet iNet_3W"
        echo ""
        echo "7.        Tableti Net_86VS"
        echo ""
        echo "8.        Tablet iNet_D978"
        echo ""
        echo "9.        Tablet inet_1"
        echo ""
        echo "10.       Pinetab"
        echo -n "       Seleccione una opcion [1 - 10]"
        read uboot
        case $uboot in

1) $make $arm q8_a13_tablet_defconfig;;
2) $make $arm q8_a23_tablet_800x480_defconfig;;
3) $make $arm q8_a33_tablet_1024x600_defconfig;;
4) $make $arm q8_a33_tablet_800x480_defconfig;;
5) $make $arm iNet_3F_defconfig ;;
6) $make $arm iNet_3W_defconfig;;
7) $make $arm iNet_86VS_defconfig;;
8) $make $arm iNet_D978_rev2_defconfig;;
9) $make $arm inet1_defconfig;;
10) $make $arm64 pinetab_defconfig;;
*) echo "$opc no es una opcion válida.";
echo "Presiona una tecla para continuar...";
read foo;
esac
sudo make -j$(nproc) ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
clear
echo "Compilación de u-boot terminada"
sleep 1
echo "Para instalar uboot en una micro-SD:"
echo "dd if=u-boot-sunxi-with-spl.bin of=tutarjetasd bs=1024 seek=8"

}
kernel() {
        wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.2.9.tar.xz
        tar -Jxvf linux-6.2.9.tar.xz
}
        general


##kernel legacy##
#echo "kernel"
#sleep 2
#echo "kernel Sunxi 3.4"
#git clone -b sunxi-3.4 https://github.com/linux-sunxi/linux-sunxi.git sunxi/kernel/3-4/linux-sunxi
