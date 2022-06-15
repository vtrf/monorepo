---
title: "Running a Raspberry Pi 4 with NixOS"
slug: "running-a-raspberry-pi-4-with-nixos"
date: "2022-05-09"
summary: |
  Configuring and running NixOS on a Raspberry Pi 4.
---

For quite some time I've been wanting to run a small homelab with [NixOS][]. I
don't host much services myself, however I feel that I can have a lot of fun
(and learn _a bit_) by maintaining my own server. All the services I run on
the Cloud™ (Matrix Dendrite and a Nix Binary Cache) could be running on a
Raspberry Pi inside my drawer. So that be it!

![A picture of Raspberry Pi inside an Argon One case and a Keychron K2V2 behind](/img/raspberry-argon.jpg)

## Table of Contents

- [Table of Contents](#table-of-contents)
- [Setup](#setup)
- [Flashing](#flashing)
- [Formatting](#formatting)
- [NixOS Configuration](#nixos-configuration)
- [Boot firmware](#boot-firmware)
- [Installing](#installing)
  - [With Channels](#with-channels)
  - [With Flakes](#with-flakes)

## Setup

At the time of writing my setup looks like this:

- Case Argon ONE M.2
- KingSpec SSD M.2 SATA - 512GB
- Random Flash Drive - 8GB (you can also use a SD Card)
- Raspberry Pi 4 - 8GB

## Flashing

Download the NixOS `aarch64` image. Personally I went with the
[unstable branch][] as I like to live dangerously but you can choose [other
versions][] if you want to. After that you just need to `dd` it to your flash
drive and boot it:

```
$ sudo dd if=nixos.img of=/dev/sdX bs=4096 conv=fsync status=progress
```

**Notes**:
- Don't forget to extract the image before flashing it.
- If using the Argon One M.2 case, don't boot the USB Drive with your SSD
  connected. Otherwise your raspberry will try to boot from the SSD and not your
  Flash Drive/SD Card.

## Formatting

You can actually follow the [NixOS Manual][] to partition your hard drive. However I've written a script to help me do this:

```sh
# replace /dev/sda with your SSD
export FMT_DISK=/dev/sda

wipefs -a $FMT_DISK

export DISK=/dev/disk/by-id/ata*

parted $FMT_DISK -- mklabel msdos
parted $FMT_DISK -- mkpart primary fat32 0MiB 512MiB # $DISK-part1 is /boot
parted $FMT_DISK -- mkpart primary 512MiB -4GiB # $DISK-part2 is the ext4 partition
parted $FMT_DISK -- mkpart primary linux-swap -4GiB 100% # Swap

mkfs.ext4 -L nixos $DISK-part2
mount $DISK-part2 /mnt

mkfs.vfat -F32 $DISK-part1
mkdir -p /mnt/boot
mount $DISK-part1 /mnt/boot
```

## NixOS Configuration

In order to boot correctly, you need to define some boot options[^1]:

```nix
{
  boot = {
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    kernelPackages = pkgs.linuxPackages_rpi4;
    kernelParams = [
      "8250.nr_uarts=1"
      "cma=128M"
      "console=tty1"
      "console=ttyAMA0,115200"
    ];

    loader = {
      raspberryPi = {
        enable = true;
        version = 4;
      };

      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
  };

  hardware.enableRedistributableFirmware = true;
}
```

## Boot firmware

The installer disk has a partition containing the necessary firmwares to boot
(it was on `/dev/sda1/` for me). Just copy it to your boot partition.

```shell
mkdir /firmware
mount /dev/sda1 /firmware
cp /firmware/* /mnt/boot
```

## Installing

### With Channels

The only step left is to install the system:

```shell
nixos-install --root /mnt
```

### With Flakes

Another way to install it is to make use of Nix [Flakes]. This way we can ensure
that our build is completely reproducible and/or running the same software
version as the other machines.

This is a rather simple process if you already have a repo configured with your
[NixOS][] configurations. First, I need a shell with `git` and a [Nix][nixos]
version that supports the experimental [Flakes][] commands.

```shell
nix-shell -p git nixUnstable
```

After that I just clone my repository, copy the `hardware-configuration.nix`
file over and install the system.

```shell
# clone the repository
git clone https://git.sr.ht/~glorifiedgluer/dotfiles
cd dotfiles

# copy hardware-configuration.nix
cp /mnt/etc/nixos/hardware-configuration.nix hosts/rpi4/

# install the system
nixos-install --flake .#rpi4
```

[^1]: https://nixos.wiki/wiki/NixOS_on_ARM/Raspberry_Pi_4#Configuration

[flakes]: https://nixos.wiki/wiki/Flakes
[nixos manual]: https://nixos.org/manual/nixos/stable
[nixos]: https://nixos.org
[other versions]: https://nixos.wiki/wiki/NixOS_on_ARM#SD_card_images_.28SBCs_and_similar_platforms.29
[unstable branch]: https://hydra.nixos.org/job/nixos/trunk-combined/nixos.sd_image_new_kernel.aarch64-linux
