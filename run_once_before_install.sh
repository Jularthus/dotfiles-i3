#!/bin/bash

IS_NIX=false
IS_FEDORA=false

if [ -f /etc/os-release ]; then
  . /etc/os-release
  case "$ID" in
    nixos)
      IS_NIX=true
      ;;
    fedora)
      IS_FEDORA=true
      ;;
  esac
fi

install_packages() {
  echo -e "\e[1;31mInstalling: All packages\e[0m"
  if $IS_NIX; then
    nix profile install nixpkgs#polybar \
                        nixpkgs#zsh\
                        nixpkgs#kitty \
                        nixpkgs#fastfetch \
                        nixpkgs#bat \
                        nixpkgs#picom \
                        nixpkgs#nodejs \
                        nixpkgs#sshfs \
                        nixpkgs#lunarvim \
                        nixpkgs#flameshot \
                        nixpkgs#ranger \
                        nixpkgs#gitkraken
  elif $IS_FEDORA; then
    sudo dnf install -y zsh kitty git sshfs picom polybar fastfetch bat nodejs flameshot ranger cargo neovim
    sudo dnf remove --noautoremove -y neovim

    # gitkraken manual
    wget https://release.gitkraken.com/linux/gitkraken-amd64.rpm
    sudo dnf install -y ./gitkraken-amd64.rpm
    rm ./gitkraken-amd64.rpm

    # bob nvim manual
    cargo install --git https://github.com/MordechaiHadad/bob.git ; $HOME/.cargo/bin/bob install 0.10.4 ; yes "n" | $HOME/.cargo/bin/bob use 0.10.4

    # lunarvim manual
    PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
    curl https://raw.githubusercontent.com/LunarVim/LunarVim/refs/heads/master/utils/installer/install.sh | bash -s -- -y
    sed -i '11s/^.\{24\}//' $HOME/.local/bin/lvim
    # LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)

  fi
}

install_fonts() {
  echo -e "\e[1;31mInstalling: Fonts\e[0m"
  if $IS_NIX; then
    nix profile install --expr 'with builtins.getFlake("flake:nixpkgs"); legacyPackages.x86_64-linux.nerdfonts.override { fonts = ["JetBrainsMono"]; }' --impure
  elif $IS_FEDORA; then
    echo "NEED SUDO FOR INSTALLING FONTS"
    mkdir -p $HOME/.local/share/fonts/JetBrainsMono/
    curl -L "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip" -o /tmp/JetBrainsMono.zip
    unzip /tmp/JetBrainsMono.zip -d $HOME/.local/share/fonts/JetBrainsMono/
    fc-cache -v
    # echo "MANUALLY INSTALL THROUGH : https://www.nerdfonts.com/font-downloads"
  fi
}

apply_wallpaper() {
  echo -e "\e[1;31mApplying: Wallpaper\e[0m"
  feh --no-fehbg --bg-scale $HOME/.local/share/chezmoi/dot_config/wallpaper/leaves2.png
}

install_ohmyzsh() {
  echo -e "\e[1;31mInstalling: Oh-my-zsh\e[0m"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

mount_fortune() {
  echo -e "\e[1;31mInstalling: Fortune folder (sshfs from ServeurKlein)\e[0m"
  mkdir -p $HOME/.config/fortune/
  sshfs -o reconnect -p 8022 jularthus@jularthus.fr:/home/jularthus/AuCoin/fortune ~/.config/fortune && touch $HOME/.fortune
}

install_packages
install_fonts
apply_wallpaper
install_ohmyzsh
mount_fortune
