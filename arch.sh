 #!/bin/sh

loadkeys ru
setfont cyr-sun16

    echo '(П.10 стр.45) Выбор ядра и основных пакетов'
DEFAULT="base base-devel linux linux-headers linux-firmware nano netctl dhcpcd"
ZEN="base base-devel linux-zen linux-zen-headers linux-firmware nano netctl dhcpcd"
LTS="base base-devel linux-lts linux-lts-headers linux-firmware nano netctl dhcpcd"

    echo 'Выбор места установки разделов (LOCATION)'
 ROOT_LOCATION=/mnt
 BOOT_LOCATION=/mnt/boot/efi
 DATA_LOCATION=/mnt/data
DATA2_LOCATION=/mnt/data2

    echo 'Выбор разделов'
 BOOT_PARTITION=/dev/sda1
 SWAP_PARTITION=/dev/nvme0n1p6
 ROOT_PARTITION=/dev/sda2
 DATA_PARTITION=/dev/sda5
DATA2_PARTITION=/dev/nvme0n1p5

    echo '01. Форматирование корневого раздела'
mkfs.ext4 $ROOT_PARTITION -L Arch
    echo '02. Монтирование корневого раздела'
mount $ROOT_PARTITION $ROOT_LOCATION
    echo '03. Создание папок для разделов с данными'
mkdir /mnt/{data,data2}
    echo '04. Создание папок /boot/efi'
mkdir -p /mnt/boot/efi
    echo '05. Монтирование загрузочного UEFI раздела'
mount $BOOT_PARTITION $BOOT_LOCATION
    echo '06. Монтирование раздела с данными 1'
mount $DATA_PARTITION $DATA_LOCATION
    echo '07. Монтирование раздела с данными 2'
mount $DATA2_PARTITION $DATA2_LOCATION
    echo 'Монтирование раздела SWAP'
swapon $SWAP_PARTITION
    echo '08. Копирование скрипта arch2.sh'
cp /1/arch2.sh /mnt/arch2.sh
    echo '09. Установка зеркал'
pacman -Sy reflector && reflector --verbose -l 5 -p sort rate --save /etc/pacman.d/mirrorlist
    echo '10. Установка ядра и основных пакетов'
pacstrap /mnt $DEFAULT
    echo '11. Генерируем fstab'
genfstab -U /mnt >> /mnt/etc/fstab
    echo '12. Имя компьютера'
echo "archlinux" >> /mnt/etc/hostname
    echo '13. Добавляем multilib'
sed -i 's/#[multilib]/[multilib]/' /mnt/etc/pacman.conf
sed -i 's/#Include = /etc/pacman.d/mirrorlist/Include = /etc/pacman.d/mirrorlist/' /mnt/etc/pacman.conf
    echo '14. Переход в новое окружение'
arch-chroot /mnt sh /arch2.sh
