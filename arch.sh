  #!/bin/bash

loadkeys ru
setfont cyr-sun16

    #echo '(П.10) Выбор ядра и основных пакетов'
        DEFAULT="base base-devel linux linux-firmware nano netctl dhcpcd"
            ZEN="base base-devel linux-zen linux-zen-headers linux-firmware nano netctl dhcpcd"
            LTS="base base-devel linux-lts linux-lts-headers linux-firmware nano netctl dhcpcd"

    #echo 'Выбор места установки разделов (LOCATION)'
  ROOT_LOCATION=/mnt
  BOOT_LOCATION=/mnt/boot/efi
  DATA_LOCATION=/mnt/data
 DATA2_LOCATION=/mnt/data2



    echo '01. Выбор раздела ROOT (/dev/xxx)'
    read -p 'DEV_' DEV_

    echo '02. Форматирование раздела ROOT'

    echo '1 - BTRFS, 2 - EXT4'
    read choice
      if [[ "$choice" == "1" ]]; then
mkfs.btrfs -L Arch -f $DEV_ && mount $DEV_ /mnt && cd /mnt && btrfs sub cre @ && btrfs sub cre @home && btrfs sub cre @cache && btrfs sub cre @log && cd / && umount /mnt
    elif [[ "$choice" == "2" ]]; then
mkfs.ext4 -L Arch $DEV_ && mount $DEV_ /mnt && mkdir /mnt/{data,data2} && mkdir -p /mnt/boot/efi && cd / && umount /mnt
      fi

    echo '03. Монтирование раздела ROOT'
        echo '1 - BTRFS, 2 - EXT4'
    read choice
      if [[ "$choice" == "1" ]]; then
mount -o noatime,autodefrag,compress=zstd,subvol=@ $DEV_ /mnt && mkdir /mnt/{home,data,data2} && mkdir -p /mnt/boot/efi && mkdir -p /mnt/var/log && mkdir -p /mnt/var/cache && mount -o noatime,autodefrag,compress=zstd,subvol=@home $DEV_ /mnt/home && mount -o noatime,autodefrag,compress=zstd,subvol=@cache $DEV_ /mnt/var/cache && mount -o noatime,autodefrag,compress=zstd,subvol=@log $DEV_ /mnt/var/log
    elif [[ "$choice" == "2" ]]; then
mount $DEV_ /mnt
      fi

    echo '04. Монтирование раздела UEFI'
read -p 'BOOT_PARTITION_' BOOT_PARTITION_
mount $BOOT_PARTITION_ $BOOT_LOCATION
    echo '05. Монтирование раздела с данными 1'
read -p 'DATA_PARTITION_' DATA_PARTITION_
mount $DATA_PARTITION_ $DATA_LOCATION
    echo '06. Монтирование раздела с данными 2'
read -p 'DATA2_PARTITION_' DATA2_PARTITION_
mount $DATA2_PARTITION_ $DATA2_LOCATION
    echo '07. Монтирование раздела SWAP'
read -p 'SWAP_PARTITION_' SWAP_PARTITION_
swapon $SWAP_PARTITION_
    echo '08. Копирование скрипта arch2.sh'
cp /1/arch2.sh /mnt/arch2.sh
    echo '09. Установка зеркал'
#pacman -Sy reflector && reflector --verbose -l 5 -p sort rate --save /etc/pacman.d/mirrorlist
    echo '10. Установка ядра и основных пакетов'
    echo '1 - DEFAULT, 2 - ZEN, 3 - LTS'
    read choice
      if [[ "$choice" == "1" ]]; then
KERNEL=$DEFAULT
    elif [[ "$choice" == "2" ]]; then
KERNEL=$ZEN
    elif [[ "$choice" == "3" ]]; then
KERNEL=$LTS
      fi
pacstrap /mnt $KERNEL
    echo '11. Генерируем fstab'
genfstab -U /mnt >> /mnt/etc/fstab
    echo '12. Имя компьютера'
read -p 'HOSTNAME_' HOSTNAME_
echo "$HOSTNAME_" >> /mnt/etc/hostname
    echo '13. Добавляем multilib'
echo "[multilib]" >> /mnt/etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist/" >> /mnt/etc/pacman.conf
    echo '14. Переход в новое окружение'
arch-chroot /mnt /bin/bash /arch2.sh
