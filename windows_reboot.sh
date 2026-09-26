#!/bin/sh
set -e
sudo efibootmgr --bootnext 0000
sudo systemctl reboot
