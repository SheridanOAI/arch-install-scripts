#!/usr/bin/bash

export PACKAGES="f2fs-tools mtools ntfs-3g p7zip unrar gparted aspell-ru firefox firefox-i18n-ru \
audacious conky telegram-desktop discord noto-fonts-emoji qbittorrent --noconfirm"

#echo '(П.21) Выбор установки videocard drivers (NVIDIA,AMD)'
export NVIDIA="xorg-server nvidia-dkms nvidia-utils nvidia-settings lib32-nvidia-utils --noconfirm"
export NV_OPEN="xorg-server nvidia-open-dkms nvidia-utils nvidia-settings lib32-nvidia-utils --noconfirm"
export AMD="xorg-server xorg-drivers --noconfirm"

#echo '(П.22) Выбор установки рабочего стола $PLASMA, $CINNAMON, $GNOME, $XFCE, $MATE, $LXQT'
export PLASMA="plasma dolphin konsole spectacle gnome-disk-utility kcalc ark \
gwenview spectacle kate gnome-mahjongg pipewire pipewire-alsa gst-plugin-pipewire \
lib32-pipewire pipewire-x11-bell pavucontrol-qt bluez-utils --noconfirm"

export CINNAMON="cinnamon cinnamon-translations networkmanager \
file-roller gnome-disk-utility gedit xfce4-terminal gnome-mahjongg \
lightdm lightdm-gtk-greeter plank pipewire pipewire-alsa pipewire-pulse \
pipewire-x11-bell gst-plugin-pipewire lib32-pipewire pavucontrol bluez-utils"

export GNOME="gnome gnome-extra networkmanager pipewire pipewire-alsa \
pipewire-pulse pipewire-x11-bell pavucontrol bluez-utils"

export XFCE="xfce4 xfce4-goodies network-manager-applet networkmanager \
lightdm lightdm-gtk-greeter plank file-roller pipewire pipewire-alsa \
pipewire-pulse gst-plugin-pipewire lib32-pipewire gnome-disk-utility \
pipewire-x11-bell picom pavucontrol bluez-utils"

export LXQT="lxqt sddm plank breeze-icons oxygen-icons networkmanager \
picom pipewire pipewire-alsa pipewire-pulse gst-plugin-pipewire \
pipewire-x11-bell lib32-pipewire pavucontrol-qt bluez-utils"

export MATE="mate mate-extra network-manager-applet engrampa \
networkmanager picom mate-media lightdm lightdm-gtk-greeter plank \
pipewire pipewire-alsa pipewire-pulse gst-plugin-pipewire \
pipewire-x11-bell lib32-pipewire pavucontrol bluez-utils"

#echo '(П.27) Выбор экранного менеджера SDDM GDM LXDM'
export SDDM=sddm
export GDM=gdm
export LIGHTDM=lightdm

echo '16. Выставляем регион'
read -p 'ZONEINFO_' ZONEINFO_
ln -sf /usr/share/zoneinfo/$ZONEINFO_ /etc/localtime

echo '17. Раскоментируем локаль системы'
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen

echo '18. Генерируем локаль системы'
locale-gen

echo '19. Указываем язык системы'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf

echo '20. Русифицируем консоль'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf

echo '21. Обновляем базу PACMAN'
pacman -Sy

echo '22. Устанавливаем NVIDIA AMD drivers'

echo '1-NVIDIA   2-NVIDIA_OPEN   3-AMD,NOUVEAU'

read choice
if [[ "$choice" == "1" ]]; then
    export DRIVERS=$NVIDIA
elif [[ "$choice" == "2" ]]; then
    export DRIVERS=$NV_OPEN
elif [[ "$choice" == "3" ]]; then
    export DRIVERS=$AMD
fi
pacman -S $DRIVERS

echo '23. Устанавливаем рабочий стол (DE)'

echo '1-PLASMA, 2-CINNAMON, 3-GNOME, 4-XFCE, 5-LXQT, 6-MATE'

read choice
if [[ "$choice" == "1" ]]; then
    export DE=$PLASMA
elif [[ "$choice" == "2" ]]; then
    export DE=$CINNAMON
elif [[ "$choice" == "3" ]]; then
    export DE=$GNOME
elif [[ "$choice" == "4" ]]; then
    export DE=$XFCE
elif [[ "$choice" == "5" ]]; then
    export DE=$LXQT
elif [[ "$choice" == "6" ]]; then
    export DE=$MATE
fi
pacman -S $DE

echo '24. Создаем root пароль'
passwd

echo '25. Создаём пользователя'
read -p 'USERNAME_' USERNAME_
useradd -m -G users,wheel,video -s /bin/bash $USERNAME_

echo '26. Вписываем такое же имя пользователя'
read -p 'USERNAME_' USERNAME_

echo '27. Создаём пароль пользователя'
passwd $USERNAME_

echo '28. Подключаем daemon SDDM, GDM, LXDM'

echo '1-SDDM-PLASMA-LXQT, 2-GDM-GNOME, 3-LIGHTDM-CINNAMON-XFCE-MATE'

read choice
if [[ "$choice" == "1" ]]; then
    export DM=$SDDM
elif [[ "$choice" == "2" ]]; then
    export DM=$GDM
elif [[ "$choice" == "3" ]]; then
    export DM=$LIGHTDM
fi
systemctl enable $DM

echo '29. Подключаем daemon NetworkManager'
systemctl enable NetworkManager

echo '30. Устанавливаем grub'
pacman -S grub os-prober efibootmgr

echo '31. Выбор диска установки grub'
#read -p 'DISK_' DISK_
grub-install #$DISK_

echo '32. Подключение os-prober'

#echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
echo '33. Обновляем grub'
grub-mkconfig -o /boot/grub/grub.cfg

echo '34. Устанавливаем программы'
pacman -S $PACKAGES

echo '35. Раскоментируем sudoers'
sed -i '82c%wheel ALL=(ALL) ALL' /etc/sudoers

echo '36. Удаляем распакованный ахив (arch-install-scripts-main)'
rm -rf /arch-install-scripts-main
