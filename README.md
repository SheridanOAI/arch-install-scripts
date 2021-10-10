#     Скрипт по установке Arch Linux.
Есть возможность установки разных ядер (DEFAULT, ZEN, LTS), а так же подстановки своих разделов для форматирования и монтирования.

    ВНИМАНИЕ!
    Не запускайте скрипты сразу так как там указаны мои разделы, внимательно изучите куда подставлять данные. 
Автор не несёт ответственность за использования этого скрипта.

    Для тех у кого стоит на флешке программа VENTOY, рекомендую записывать скрипты во второй раздел установочной флешки ventoy.
Для этого необходимо смонтировать второй раздел  установочной флешки ventoy в ваш систему.
    Сначала вставьте флешку с программой ventoy, затем в консоле введите команду #fdisl -l и посмотрите под каким буквенно цифровым номером ваша флешка
    (в моём случае sdb2)
пример:
монтируемся в #mount /sdb2 /mnt , затем копируем в /mnt два скрипта (arch.sh, arch2.sh),
набрав команду в консоли #cp /путь где лежат скрипты/{arch.sh,arch2.sh} /mnt
1. Загружаемся с установочного диска Arch
2. В консоли создаём папку для монтирования второго раздела Ventoy #mkdir /1
3. Монтируем второй раздел Ventoy (в моём случае #mount /dev/sdb2 /1)
4. Заупускаем скрипт arch.sh  #/1/arch.sh
Если у кого установочный образ Arch установлен на флешку, необходимо вставить дополнительную флешку с записанными на ней скриптами,
1. Создаём папку #mkdir /1
2. Монтируем флешку #mount /dev/sdX2 /1
3. Запускаем скрипт #/1/arch.sh

    В этих локациях я указываю куда подключать ваши разделы.(скрипт arch.sh)
ROOT_LOCATION=/mnt
BOOT_LOCATION=/mnt/boot/efi
DATA_LOCATION=/mnt/data
DATA2_LOCATION=/mnt/data2

    В этих партициях я указываю разделы которые небходимо подключить. (скрипт arch.sh)
 BOOT_PARTITION=/dev/sda1
 SWAP_PARTITION=/dev/nvme0n1p6
 ROOT_PARTITION=/dev/sda2
 DATA_PARTITION=/dev/sda5
DATA2_PARTITION=/dev/nvme0n1p5

    Здесь я делаю выбор с каким ядром подключится
DEFAULT=
ZEN=
LTS=
Свой выбор вы вносите в (П.10 стр.45 arch.sh).

    Для выбора рабочего стола (строка.13 arch2.sh) вам необходимо выбрать DE ($DE_PLASMA,$DE_CINNAMON,$DE_GNOME,$DE_XFCE$DE_MATE)
и указать в (П.36 стр.37) какой рабочий стол необходимо подключить (по умолчанию KDE Plasma).
В разделе PACKAGES= я указываю какие программы необходимы мне при установке, можете добавлять или удалить не нужные.

    В этом разделе я выбираю установку драйвера Nvidia в зависимости от установленного ядра в скрипте (П.10.стр.45 arch.sh),
для этого необходимо в (П21. стр.35 arch2.sh) внести свой выбор.
NVIDIA_DEFAULT="nvidia"
NVIDIA_ZEN="nvidia-dkms"
NVIDIA_LTS="nvidia-lts"

    Для тех у кого видеокарта AMD_ATI необходимо внести $AMD_ATI в (П.21. стр.35 arch2.sh)

    От автора: Удачной установки!
