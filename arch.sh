#!/usr/bin/bash

loadkeys ru
setfont cyr-sun16
pacman -Sy
pacman -S unzip wget 
pacman-key --init
pacman-key --populate archlinux

#echo '(П.10) Выбор ядра и основных пакетов'
export VANILLA="base base-devel linux linux-headers linux-firmware nano netctl dhcpcd amd-ucode"
export ZEN="base base-devel linux-zen linux-zen-headers linux-firmware nano netctl dhcpcd amd-ucode"
export LTS="base base-devel linux-lts linux-lts-headers linux-firmware nano netctl dhcpcd amd-ucode"

#echo 'Выбор места установки разделов (LOCATION)'
export ROOT_LOCATION=/mnt
export BOOT_LOCATION=/mnt/boot/efi
export DATA_LOCATION=/mnt/home/data
export DATA2_LOCATION=/mnt/home/data2
export GAMES_LOCATION=/mnt/home/games

echo '01. Выбор раздела ROOT (/dev/xxx)'

read -p 'DEV_' DEV_

echo '02. Форматирование раздела ROOT'

echo '1 - BTRFS, 2 - EXT4'

read choice
if [[ "$choice" == "1" ]]; then
    mkfs.btrfs -L Arch -f $DEV_ && mount $DEV_ /mnt &&
    cd /mnt && btrfs sub cre @ && btrfs sub cre @home &&
    btrfs sub cre @cache && btrfs sub cre @log && cd / && umount /mnt
elif [[ "$choice" == "2" ]]; then
    mkfs.ext4 -L Arch $DEV_ && mount $DEV_ /mnt &&
    mkdir -p /mnt/home/{data,data2,games} && mkdir -p /mnt/boot/efi &&
    cd / && umount /mnt
fi

echo '03. Монтирование раздела ROOT'

echo '1 - BTRFS, 2 - EXT4'

read choice
if [[ "$choice" == "1" ]]; then
    mount -o rw,noatime,ssd,discard=async,compress=zstd,subvol=@ $DEV_ /mnt &&
    mkdir -p /mnt/home && mkdir -p /mnt/boot/efi &&
    mkdir -p /mnt/var/log && mkdir -p /mnt/var/cache &&
    mount -o rw,noatime,ssd,discard=async,compress=zstd,subvol=@home $DEV_ /mnt/home &&
    mkdir -p /mnt/home/{data,data2,games} &&
    mount -o rw,noatime,ssd,discard=async,compress=zstd,subvol=@cache $DEV_ /mnt/var/cache &&
    mount -o rw,noatime,ssd,discard=async,compress=zstd,subvol=@log $DEV_ /mnt/var/log
elif [[ "$choice" == "2" ]]; then
    mount $DEV_ /mnt
fi

echo '04. Монтирование раздела UEFI'
read -p 'BOOT_PARTITION_' BOOT_PARTITION_
mount $BOOT_PARTITION_ $BOOT_LOCATION

echo '05. Монтирование раздела DATA'
read -p 'DATA_PARTITION_' DATA_PARTITION_
mount $DATA_PARTITION_ $DATA_LOCATION

echo '06. Монтирование раздела DATA2'
read -p 'DATA2_PARTITION_' DATA2_PARTITION_
mount $DATA2_PARTITION_ $DATA2_LOCATION

echo '07. Монтирование раздела GAMES'
read -p 'GAMES_PARTITION_' GAMES_PARTITION_
mount $GAMES_PARTITION_ $GAMES_LOCATION

echo '08. Монтирование раздела SWAP'
read -p 'SWAP_PARTITION_' SWAP_PARTITION_
swapon $SWAP_PARTITION_

echo '09. Копирование и распаковка архива с github'
wget https://github.com/SheridanOAI/arch-install-scripts/archive/refs/heads/main.zip
unzip main.zip -d /mnt

echo '10. Установка зеркал'
pacman -Sy reflector && reflector --verbose -l 5 -p sort rate --save /etc/pacman.d/mirrorlist

echo '11. Установка ядра и основных пакетов'

echo '1 - VANILLA, 2 - ZEN, 3 - LTS'

read choice
if [[ "$choice" == "1" ]]; then
    export KERNEL=$VANILLA
elif [[ "$choice" == "2" ]]; then
    export KERNEL=$ZEN
elif [[ "$choice" == "3" ]]; then
    export KERNEL=$LTS
fi
pacstrap /mnt $KERNEL

echo '12. Генерируем fstab'
genfstab -U /mnt >> /mnt/etc/fstab

echo '13. Имя компьютера'
read -p 'HOSTNAME_' HOSTNAME_

echo "$HOSTNAME_" >> /mnt/etc/hostname

echo '14. Добавляем multilib'
sed -i '93c[multilib]' /mnt/etc/pacman.conf ; sed -i '94cInclude = /etc/pacman.d/mirrorlist' /mnt/etc/pacman.conf

echo '15. Переход в новое окружение'
arch-chroot /mnt /bin/bash /arch-install-scripts-main/arch2.sh
