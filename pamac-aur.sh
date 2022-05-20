 #!/bin/bash

#Install Pamac-aur
sudo pacman -S git go
git clone https://aur.archlinux.org/yay.git
curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/''yay''.tar.gz
cd yay
makepkg
sudo pacman -U yay-*.zst
yay -S pamac-aur archlinux-appstream-data-pamac inxi
cd ..
rm -rf yay
rm yay.tar.gz
#Install printer Konika-Minolta-PgePro-1300w
sudo pacman -U /data/Temp/Linux/ArchLinux/Printer/printer-driver-min12xxw-0.0.9-1-x86_64.pkg.tar.zst
sudo pacman -S cups cups-pdf print-manager system-config-printer
systemctl enable cups.service
systemctl start cups.service
#Install PipeWire
sudo pacman -Sy pipewire-alsa pipewire-pulse gst-plugin-pipewire neofetch glxinfo
#color console
sudo sh -c 'sed -i '33cColor' /etc/pacman.conf'
sudo cp /data/Temp/Linux/ArchLinux/Scripts/.bashrc ~/.bashrc
echo "PS1='\[\e[0;31m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\$\[\e[m\] '" | sudo tee -a /root/.bashrc
cp -r -p /data/Temp/Linux/ArchLinux/bin ~/bin
cp /etc/nanorc ~/.nanorc
sudo pacman -S nano-syntax-highlighting
echo 'include "/usr/share/nano-syntax-highlighting/*.nanorc"' > ~/.nanorc
sudo sh -c 'echo include \"/usr/share/nano-syntax-highlighting/*.nanorc\" >> /etc/nanorc'
