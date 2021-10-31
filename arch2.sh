 #!/bin/bash

PACKAGES="f2fs-tools dosfstools ntfs-3g p7zip unrar ark aspell-ru firefox firefox-i18n-ru gwenview flameshot kate audacious gnome-disk-utility gnome-mahjongg conky ttf-liberation ttf-dejavu"

    echo '(П.21 стр.46) Выбор установки nvidia drivers c kernel ($NV_DEFAULT,$NV_ZEN,$NV_LTS),'
NV_DEFAULT="nvidia nvidia-settings"
NV_ZEN="nvidia-dkms nvidia-settings"
NV_LTS="nvidia-lts nvidia-settings"

    echo '(П.21 стр.46) Установка AMD_ATI drivers'
AMD_ATI="xorg-server xorg-drivers"

    echo '(П.22 стр.48) Выбор установки рабочего стола PLASMA,CINNAMON,GNOME,XFCE,MATE'
DE_PLASMA="plasma dolphin pavucontrol-qt packagekit-qt5"
DE_CINNAMON="cinnamon cinnamon-translations networkmanager lightdm"
DE_GNOME="gnome gnome-extra networkmanager pavucontrol"
DE_XFCE="xfce4 xfce4-goodies networkmanager lightdm"
DE_MATE="mate mate-extra networkmanager lightdm"

    echo '(П.24 стр.52) Имя пользователя'
USERNAME=sheridan

    echo '(П.25 стр.54) Пароль пользователя'
USERPASS=sheridan

    echo '(П.27 стр.58) Выбор экранного менеджера SDDM GDM lightdm'
SDDM=systemctl enable sddm
GDM=systemctl enable gdm
LIGHTDM=systemctl enable lightdm

    echo '15. Выставляем регион'
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
    echo '16. Раскоментируем локаль системы'
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen
    echo '17. Генерируем локаль системы'
locale-gen
    echo '18. Указываем язык системы'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf
    echo '19. Русифицируем консоль'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
    echo '20. Обновляем базу PACMAN'
pacman -Sy
    echo '21. Устанавливаем NVIDIA AMD_ATI drivers'
pacman -S $NV_DEFAULT
    echo '22. Устанавливаем рабочий стол (DE)'
pacman -S $DE_PLASMA
    echo '23. Создаем root пароль'
passwd
    echo '24. Создаём пользователя'
useradd -m -G users,wheel,audio,video -s /bin/bash $USERNAME
    echo '25. Устанавливаем пароль пользователя'
passwd $USERPASS
    echo '26. Раскоментируем sudoers'
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
    echo '27. Подключаем daemon SDDM, GDM, LIGHTDM'
$SDDM
    echo '28. Подключаем daemon NetworkManager'
systemctl enable NetworkManager
    echo '29 Устанавливаем grub'
pacman -S grub os-prober efibootmgr
grub-install /dev/sda
    echo '30. Подключение os-prober'
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
    echo '31. Обновляем grub'
grub-mkconfig -o /boot/grub/grub.cfg
    echo '32. Устанавливаем программы'
pacman -S $PACKAGES
