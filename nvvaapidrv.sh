 #!/usr/bin/env bash

echo '01. Установка необходимых пакетов'
sudo pacman -S nvtop libva-utils
yay -S nvidia-vaapi-driver-git

echo '02. Добавить параметры в /etc/environment'
echo 'LIBVA_DRIVER_NAME=nvidia' | sudo tee -a /etc/environment
echo 'MOZ_DISABLE_RDD_SANDBOX=1' | sudo tee -a /etc/environment
echo 'EGL_PLATFORM=X11' | sudo tee -a /etc/environment

#echo '03. Добавить параметр nvidia-drm.modeset=1'
sudo sh -c "sed -i '6cGRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet nvidia-drm.modeset=1\"' /etc/default/grub"

#echo '04. Добавить параметры в mkinitcpio.conf'
sudo sh -c "sed -i '7cMODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)' /etc/mkinitcpio.conf"
echo '05. Обновить initramfs'
sudo mkinitcpio -P
echo '06. Обновить GRUB'
sudo grub-mkconfig -o /boot/grub/grub.cfg
