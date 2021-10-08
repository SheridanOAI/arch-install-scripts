 #!/bin/sh

PACKAGES="f2fs-tools dosfstools ntfs-3g p7zip unrar ark aspell-ru firefox firefox-i18n-ru yakuake packagekit-qt5 gwenview flameshot kate dolphin audacious pavucontrol-qt gnome-disk-utility gnome-mahjongg conky ttf-liberation ttf-dejavu"

TOOLS="grub os-prober efibootmgr plasma nvidia-settings"

NVIDIA_DEFAULT="nvidia"
NVIDIA_ZEN="nvidia-dkms"
NVIDIA_LTS="nvidia-lts"

    echo '15. Выставляем регион'
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
    echo '16. Раскоментируем локаль системы'
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
sed -i 's/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen
    echo '17. Генерируем локаль системы'
locale-gen
    echo '18. Указываем язык системы'
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf
    echo '19. Русифицыруем консоль'
echo 'KEYMAP=ru' >> /etc/vconsole.conf
echo 'FONT=cyr-sun16' >> /etc/vconsole.conf
    echo '20. Обновляем базу PACMAN'
pacman -Sy
    echo '21. Устанавливаем DE Plasma NVIDIA GRUB'
pacman -S $NVIDIA_DEFAULT $TOOLS
    echo '22. Создаем root пароль'
passwd
    echo '23. Создаём пользователя'
useradd -m -G users,wheel,audio,video -s /bin/bash sheridan
    echo '24. Устанавливаем пароль пользователя'
passwd sheridan
    echo '25. Раскоментируем sudoers'
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
    echo '26. Включаем daemon SDDM'
systemctl enable sddm
    echo '27. Включаем daemon NetworkManager'
systemctl enable NetworkManager
    echo '28 Устанавливаем grub'
grub-install /dev/sda
    echo '29. Подключение os-prober'
echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
    echo '30. Обновляем grub'
grub-mkconfig -o /boot/grub/grub.cfg
    echo '31. Устанавливаем программы'
pacman -S $PACKAGES
