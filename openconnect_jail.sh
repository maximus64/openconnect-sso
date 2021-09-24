#!/bin/sh
set -e

if [ $(id -u) != 0 ] ; then
    echo "Must be run as root"
    exit 1
fi

if ip tuntap show | grep -qs tun0; then
    echo '[+] ip tun device already exist'
    ip address flush tun0
else
    echo '[+] create ip tun device'
    ip tuntap add tun0 mode tun user openconnect
fi

if grep -qs '/var/lib/openconnect/chroot_jail ' /proc/mounts; then
    echo '[+] chroot jail env already mounted'
else
    echo '[+] Setting up chroot jail'
    mount -t tmpfs -o size=10M none /var/lib/openconnect/chroot_jail
    mkdir /var/lib/openconnect/chroot_jail/{bin,lib64,usr,dev,etc}
    mkdir /var/lib/openconnect/chroot_jail/dev/net
    mkdir -p /var/lib/openconnect/chroot_jail/var/lib/openconnect

    cp -a /dev/net/tun /var/lib/openconnect/chroot_jail/dev/net/tun
    cp -a /etc/resolv.conf /var/lib/openconnect/chroot_jail/etc/resolv.conf
    cp -a /etc/host.conf /var/lib/openconnect/chroot_jail/etc/host.conf

    cp -a /var/lib/openconnect/vpnc-script /var/lib/openconnect/chroot_jail/var/lib/openconnect/vpnc-script

    mount -o bind,ro /bin /var/lib/openconnect/chroot_jail/bin
    mount -o bind,ro /lib64 /var/lib/openconnect/chroot_jail/lib64
    mount -o bind,ro /usr /var/lib/openconnect/chroot_jail/usr
fi

cat - | chroot --userspec=openconnect:openconnect /var/lib/openconnect/chroot_jail /usr/bin/openconnect $@
