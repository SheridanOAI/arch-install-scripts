 #!/bin/bash

sudo pacman -S git go
git clone https://aur.archlinux.org/yay.git
curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/''yay''.tar.gz
cd yay
makepkg
sudo pacman -U yay-*.zst
yay -S pamac-aur
yay -S archlinux-appstream-data-pamac
cd ..
rm -rf yay
rm yay.tar.gz
