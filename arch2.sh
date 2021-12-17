 #!/bin/bash

  PACKAGES="f2fs-tools dosfstools ntfs-3g p7zip unrar ark aspell-ru firefox firefox-i18n-ru gwenview flameshot kate audacious gnome-disk-utility gnome-mahjongg conky ttf-liberation ttf-dejavu"

    echo '(П.21) Выбор установки nvidia drivers c kernel ($NV_DEFAULT,$NV_ZEN,$NV_LTS),'
NV_DEFAULT="nvidia nvidia-settings"
    NV_ZEN="nvidia-dkms nvidia-settings"
    NV_LTS="nvidia-lts nvidia-settings"
   AMD_ATI="xorg-server xorg-drivers"

    echo '(П.22) Выбор установки рабочего стола $PLASMA, $CINNAMON, $GNOME, $XFCE, $MATE'
    PLASMA="plasma dolphin pavucontrol-qt"
  CINNAMON="cinnamon cinnamon-translations networkmanager lxdm pulseaudio pavucontrol"
     GNOME="gnome gnome-extra networkmanager pavucontrol"
      XFCE="xfce4 xfce4-goodies networkmanager lxdm pulseaudio picom pavucontrol"
      MATE="mate mate-extra network-manager-applet networkmanager picom mate-media lxdm pulseaudio pavucontrol"

    echo '(П.27) Выбор экранного менеджера SDDM GDM LXDM'
     SDDM=sddm
      GDM=gdm
     LXDM=lxdm

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
    echo '22. Устанавливаем NVIDIA AMD_ATI drivers'
    echo '1 - NV_DEFAULT, 2 - NV_ZEN, 3 - NV_LTS, 4 - AMD_ATI'
    read choice
      if [[ "$choice" == "1" ]]; then
DRIVERS=$NV_DEFAULT
    elif [[ "$choice" == "2" ]]; then
DRIVERS=$NV_ZEN
    elif [[ "$choice" == "3" ]]; then
DRIVERS=$NV_LTS
    elif [[ "$choice" == "4" ]]; then
DRIVERS=$AMD_ATI
      fi
pacman -S $DRIVERS
    echo '23. Устанавливаем рабочий стол (DE)'
    echo '1 - PLASMA, 2 - CINNAMON, 3 - GNOME, 4 - XFCE, 5 - MATE'
    read choice
      if [[ "$choice" == "1" ]]; then
DE=$PLASMA
    elif [[ "$choice" == "2" ]]; then
DE=$CINNAMON
    elif [[ "$choice" == "3" ]]; then
DE=$GNOME
    elif [[ "$choice" == "4" ]]; then
DE=$XFCE
    elif [[ "$choice" == "5" ]]; then
DE=$MATE
      fi
pacman -S $DE
    echo '24. Создаем root пароль'
passwd
    echo '25. Создаём пользователя'
read -p 'USERNAME_' USERNAME_
useradd -m -G users,wheel,audio,video -s /bin/bash $USERNAME_
    echo '26. Вписываем такое же имя пользователя'
read -p 'USERNAME_' USERNAME_
    echo '27. Создаём пароль пользователя'
passwd $USERNAME_
    echo '28. Раскоментируем sudoers'
sed -i 's/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers
    echo '29. Подключаем daemon SDDM, GDM, LXDM'
    echo '1 - PLASMA - SDDM, 2 - GNOME - GDM, 3 - CINNAMON-XFCE-MATE - LXDM'
    read choice
      if [[ "$choice" == "1" ]]; then
DM=$SDDM
    elif [[ "$choice" == "2" ]]; then
DM=$GDM
    elif [[ "$choice" == "3" ]]; then
DM=$LXDM
      fi
systemctl enable $DM
    echo '30. Подключаем daemon NetworkManager'
systemctl enable NetworkManager
    echo '31. Устанавливаем grub'
pacman -S grub os-prober efibootmgr
    echo '32. Выбор диска установки grub'
read -p 'DISK_' DISK_
grub-install $DISK_
    echo '33. Подключение os-prober'
#echo "GRUB_DISABLE_OS_PROBER=false" >> /etc/default/grub
    echo '34. Обновляем grub'
grub-mkconfig -o /boot/grub/grub.cfg
    echo '35. Устанавливаем программы'
pacman -S $PACKAGES
