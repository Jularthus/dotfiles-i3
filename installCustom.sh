#!/usr/bin/env bash

init() {
profile_path="/tmp/cfg_profile"
echo '#!/bin/bash' > "$profile_path"
}

add_var() {
  local varname="$1"
  echo "export $varname=true" >> "$profile_path"
}

ask_cfg() {
init
options=('Quit' 'CFG_NO_PACKAGES' 'CFG_NO_FONTS' 'CFG_NO_WALLPAPER' 'CFG_NO_OHMYZSH' 'CFG_NO_FORTUNE' 'CFG_NO_POLYBAR' 'CFG_NO_PICOM' 'CFG_NO_WS_RENAMER' 'CFG_NO_KILL_TERMINAL' 'CFG_NO_LUNARVIM' 'CFG_NO_ROFI_FONTS')

echo "Select componants you do NOT want installed :"
select opt in "${options[@]}"; do
	if [[ -z "$opt" ]]; then
		break
	fi
  if [[ "$opt" == "Quit" ]]; then
    break
  fi
  add_var $opt
  echo "Adding : $opt"
done

# add confirmation script
echo
echo "This is the config file generated: "
echo
cat /tmp/cfg_profile ;
echo
}
ask_cfg



while true; do
    read -rp "Is this configuration ok ? [y/n] " answer
    case "$answer" in
      [Yy]) break ;;   
      [Nn]) ask_cfg ;;   
      *)  break ;;
    esac
  done

echo INSTALLING CHEZMOI
if [ -f /etc/os-release ]; then
  . /etc/os-release
  case "$ID" in
    nixos)
      nix profile install nixpkgs#chezmoi ;
      ;;
    fedora)
sh -c "$(curl -fsLS get.chezmoi.io)" ;
      
      ;;
  esac
fi

chezmoi init git@github.com:Jularthus/dotfiles-i3.git ;
/home/jules-arthus.klein/.local/share/chezmoi/run_once_before_install.sh ; chezmoi apply ; chmod +x $HOME/.config/rofi/powermenu/type-4/powermenu.sh $HOME/.config/rofi/launchers/type-2/launcher.sh
