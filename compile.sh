#!/bin/bash
# variables
arm=ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
arm64=ARCH=ARM64 CROSS_COMPILE=aarch64-linux-gnu-
make="sudo make -j$(nproc)"
montar() {
	sudo mount -o bind /dev /system/dev && sudo mount -o bind /dev/pts /system/dev/pts && sudo mount -t sysfs sys /system/sys && sudo mount -t proc proc /system/proc
}
debootstrap-second-stage() {
	cp /usr/bin/qemu-arm-static /system/usr/bin
	> config.sh
	cat <<+ >> config.sh
	#!/bin/sh
echo " Configurando debootstrap segunda fase"
sleep 3
/debootstrap/debootstrap --second-stage
export LANG=C
echo "nameserver 8.8.8.8" > /etc/resolv.conf
echo "Europe/Berlin" > /etc/timezone
echo "system" >> /etc/hostname
echo "127.0.0.1 system localhost
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts" >> /etc/hosts
echo "auto lo
iface lo inet loopback" >> /etc/network/interfaces
echo "/dev/mmcblk0p1 /	   ext4	    errors=remount-ro,noatime,nodiratime 0 1" >> /etc/fstab
echo "tmpfs    /tmp        tmpfs    nodev,nosuid,mode=1777 0 0" >> /etc/fstab
echo "tmpfs    /var/tmp    tmpfs    defaults    0 0" >> /etc/fstab	
apt-get update
echo "Reconfigurando parametros locales"
locale-gen es_ES.UTF-8
export LC_ALL="es_ES.UTF-8"
update-locale LC_ALL=es_ES.UTF-8 LANG=es_ES.UTF-8 LC_MESSAGES=POSIX
dpkg-reconfigure locales
dpkg-reconfigure -f noninteractive tzdata
apt-get upgrade -y 
hostnamectl set-hostname system
apt-get clean
adduser system
addgroup system sudo
addgroup system adm
addgroup system users
echo "Sistema Instalado"
exit
+
chmod +x  config.sh
sudo cp config.sh /system/home
chroot /system /usr/bin/qemu-arm-static /bin/sh -i ./home/config.sh
cp out/zImage /system/boot

}
dependencias() {
	apt install -y swig python-dev python3-dev gcc-arm-linux-gnueabihf bison flex make python3-setuptools libssl-dev u-boot-tools device-tree-compiler gcc-aarch64-linux-gnu binutils-aarch64-linux-gnu btrfs-tools qemu-user-static
	clear
	echo " Completado"
	general
	
}
clear
general(){
echo "		Que desea hacer hoy "
sleep 1
echo "		Elija una opción "
sleep 1
echo "1.	Instalar dependencias RECOMENDADO "
echo""
echo "2.	Compilar u-boot "
echo ""
echo "3.	Compilar kernel"
echo ""
echo "4.	Crear rootFS"
echo ""
echo "5.	Salir"
read menu
case $menu in
        1) dependencias;;
        2) uboot;;
        3) kernel;;
        4) rootfs;;
        5) exit;;
        *) echo "$opc no es una opcion válida.";
echo "Presiona una tecla para continuar...";
read foo;
esac
}
clear
uboot(){
        git clone git://git.denx.de/u-boot.git
        cd u-boot
        make mrproper
        make clean
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
        echo ""
        echo -n "       Seleccione una opcion [1 - 10]"
        read uboot
        case $uboot in

1) dtb=sun8i-a33-q8-tablet.dtb; $make $arm q8_a13_tablet_defconfig;;
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
sudo make -j$(nproc) $arm
cd ..
mkdir out
cp u-boot/u-boot-sunxi-with-spl.bin  out/
> out/boot.cmd
cat <<+ >> out/boot.cmd
setenv bootargs console=ttyS0,115200 root=/dev/mmcblk0p1 rootwait panic=10
load mmc 0:1 0x43000000 sun8i-a33-q8-tablet.dtb || load mmc 0:1 0x43000000 boot/sun8i-a33-q8-tablet.dtb
load mmc 0:1 0x42000000 zImage || load mmc 0:1 0x42000000 boot/zImage
bootz 0x42000000 - 0x43000000
+
mkimage -C none -A arm -T script -d out/boot.cmd out/boot.scr
clear
echo "Compilación de u-boot terminada"
sleep 1
echo "Para instalar uboot en una micro-SD:"
echo "dd if=u-boot-sunxi-with-spl.bin of=tutarjetasd bs=1024 seek=8"
sleep 1
echo " Copie el archivo boot.scr en la carpeta /boot de destino"
general

}
clear
kernel() {
        wget https://cdn.kernel.org/pub/linux/kernel/v6.x/linux-6.2.9.tar.xz
        tar -Jxvf linux-6.2.9.tar.xz
        cd linux-6.2.9
        make mrproper
        make clean
        make $arm sunxi_defconfig
        make $arm zImage dtbs
        $arm INSTALL_MOD_PATH=modules make modules modules_install
        cd ..
        cp -R linux-6.2.9/modules/lib out
        cp linux-6.2.9/arch/arm/boot/zImage out
        cp  /arch/arm/boot/$dtb /system/boot
        clear
        echo "Compilación del kernel terminada"
        general
        cp linux-6.2.9/arch/arm/boot/dts/sun8i-a33-q8-tablet.dtb out/
}
clear
rootfs-image() {
	mkdir /tmp/ramdisk
	mount -t tmpfs none /tmp/ramdisk -o size=1024M
	mkdir /system
	dd if=/dev/zero of=/tmp/ramdisk/system.img bs=1 count=0 seek=800M
	mkfs.ext4 /tmp/ramdisk/system.img
	chmod 777 /tmp/ramdisk/system.img
	mount -o loop /tmp/ramdisk/system.img /system
	
}
rootfs() {
	rm -R /system
	mkdir system
	echo " Menu para creación del sistema Operativo"
	echo ""
    echo "1.	Ubuntu 22 Jammy Jellyfish"
    echo ""
    echo "2.	Ubuntu 20 Focal Fosa"
    echo ""
    echo "3.	Ubuntu 18 Bionic Beaver"
    echo ""	
   	echo "4.	Ubuntu 16 Xenial Xerus"
    echo ""
   	echo "5.	Ubuntu 14 Trusty Thar"
    echo ""
    echo "6.	Debian Bullseye"
    echo ""
    echo "7.	Debian Buster"
    echo ""
    echo "8.	Debian stretch"
	read rootfs
	case $rootfs in
	1) rootfs-image; debootstrap --arch=armhf --foreign jammy /system; montar; debootstrap-second-stage;;
	2) rootfs-image; debootstrap --arch=armhf --foreign focal /system; montar; debootstrap-second-stage;;
	3) rootfs-image; debootstrap --arch=armhf --foreign bionic /system; montar; debootstrap-second-stage;;
	4) rootfs-image; debootstrap --arch=armhf --foreign xenial /system; montar; debootstrap-second-stage;;
	5) rootfs-image; debootstrap --arch=armhf --foreign trusty /system; montar; debootstrap-second-stage;;
	6) rootfs-image; debootstrap --arch=armhf --foreign bullseye /system; montar; debootstrap-second-stage;;
	7) rootfs-image; debootstrap --arch=armhf --foreign buster  /system; montar; debootstrap-second-stage;;
	8) rootfs-image; debootstrap --arch=armhf --foreign stretch /system; montar; debootstrap-second-stage;;
*) echo "$opc no es una opcion válida.";
echo "Presiona una tecla para continuar...";
read foo;
esac
cp /tmp/ramdisk/system.img out
general
}
clear
general

##kernel legacy##
#echo "kernel"
#sleep 2
#echo "kernel Sunxi 3.4"
#git clone -b sunxi-3.4 https://github.com/linux-sunxi/linux-sunxi.git sunxi/kernel/3-4/linux-sunxi
