#!/bin/bash

echo -e "\e[1;31mInstalling: All packages\e[0m"
nix profile install nixpkgs#polybar\
                    nixpkgs#fastfetch\
                    nixpkgs#bat\
                    nixpkgs#nodejs\
                    nixpkgs#lunarvim\
                    nixpkgs#flameshot\
                    nixpkgs#ranger\
                    nixpkgs#gitkraken

# font (jetbrains)
echo -e "\e[1;31mInstalling: Fonts\e[0m"
nix profile install --expr 'with builtins.getFlake("flake:nixpkgs"); legacyPackages.x86_64-linux.nerdfonts.override { fonts = ["JetBrainsMono"]; }' --impure

# wallpaper
echo -e "\e[1;31mApplying: Wallpaper\e[0m"
/run/current-system/sw/bin/feh --no-fehbg --bg-scale ~/.config/wallpaper/leaves2.png

# installation oh my zsh
echo -e "\e[1;31mInstalling: Oh-my-zsh\e[0m"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" 

# mount fortune folder
echo -e "\e[1;31mInstalling: Fortune folder (sshfs from ServeurKlein)\e[0m"
echo -e "\033[1mDISABLED FOR NOW ; USE fortuneStart INSTEAD\033[0m"
# sshfs -o reconnect -p 8022 jularthus@jularthus.fr:/home/jularthus/fortune .config/fortune

# launch polybar
echo -e "\e[1;31mKilling i3bar\e[0m"
killall i3bar
killall polybar
echo -e "\e[1;31mLaunching: Polybar\e[0m"
polybar >/dev/null 2>&1 &
