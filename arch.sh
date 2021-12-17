 #!/bin/bash

loadkeys ru
setfont cyr-sun16

    echo '(П.10) Выбор ядра и основных пакетов'
        DEFAULT="base base-devel linux linux-firmware nano netctl dhcpcd"
            ZEN="base base-devel linux-zen linux-zen-headers linux-firmware nano netctl dhcpcd"
            LTS="base base-devel linux-lts linux-lts-headers linux-firmware nano netctl dhcpcd"

    echo 'Выбор места установки разделов (LOCATION)'
  ROOT_LOCATION=/mnt
  BOOT_LOCATION=/mnt/boot/efi
  DATA_LOCATION=/mnt/data
 DATA2_LOCATION=/mnt/data2

    echo 'Выбор FS ROOT раздела'
        FS_TYPE=ext4

    echo '01. Форматирование корневого раздела'
read -p 'ROOT_PARTITION_' ROOT_PARTITION_
mkfs.$FS_TYPE $ROOT_PARTITION_ -L Arch
    echo '02. Монтирование корневого раздела'
read -p 'ROOT_PARTITION_' ROOT_PARTITION_
mount $ROOT_PARTITION_ $ROOT_LOCATION
    echo '03. Создание папок для разделов с данными'
mkdir /mnt/{data,data2}
    echo '04. Создание папок /boot/efi'
mkdir -p /mnt/boot/efi
    echo '05. Монтирование загрузочного UEFI раздела'
read -p 'BOOT_PARTITION_' BOOT_PARTITION_
mount $BOOT_PARTITION_ $BOOT_LOCATION
    echo '06. Монтирование раздела с данными 1'
read -p 'DATA_PARTITION_' DATA_PARTITION_
mount $DATA_PARTITION_ $DATA_LOCATION
    echo '07. Монтирование раздела с данными 2'
read -p 'DATA2_PARTITION_' DATA2_PARTITION_
mount $DATA2_PARTITION_ $DATA2_LOCATION
    echo '08. Монтирование раздела SWAP'
read -p 'SWAP_PARTITION_' SWAP_PARTITION_
swapon $SWAP_PARTITION_
    echo '09. Копирование скрипта arch2.sh'
cp /1/arch2.sh /mnt/arch2.sh
    echo '10. Установка зеркал'
#pacman -Sy reflector && reflector --verbose -l 5 -p sort rate --save /etc/pacman.d/mirrorlist
    echo '11. Установка ядра и основных пакетов'
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
    echo '12. Генерируем fstab'
genfstab -U /mnt >> /mnt/etc/fstab
    echo '13. Имя компьютера'
read -p 'HOSTNAME_' HOSTNAME_
echo "$HOSTNAME_" >> /mnt/etc/hostname
    echo '14. Добавляем multilib'
echo "[multilib]" >> /mnt/etc/pacman.conf
echo "Include = /etc/pacman.d/mirrorlist/" >> /mnt/etc/pacman.conf
    echo '15. Переход в новое окружение'
arch-chroot /mnt /bin/bash /arch2.sh
