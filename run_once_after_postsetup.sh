#!/bin/sh

if [ -f $HOME/.cfg2 ]; then
  exit
fi

touch $HOME/.cfg2

source /tmp/cfg_profile

apply_wallpaper() {
  echo -e "\e[1;31mApplying: Wallpaper\e[0m"
  feh --no-fehbg --bg-fill $HOME/.config/wallpaper/cooper1.jpeg
}

install_rofi_fonts() {
   echo -e "\e[1;31mInstalling Rofi Fonts\e[0m"

   DIR="$HOME/.config/rofi"
   FONT_DIR="$HOME/.local/share/fonts"

	if [[ -d "$FONT_DIR" ]]; then
		cp -rf $DIR/fonts/* "$FONT_DIR"
	else
		mkdir -p "$FONT_DIR"
		cp -rf $DIR/fonts/* "$FONT_DIR"
	fi
	fc-cache

  chmod +x $HOME/.config/rofi/launchers/type-2/launcher.sh
  chmod +x $HOME/.config/rofi/powermenu/type-4/powermenu.sh
}

launch_polybar() {
  echo -e "\e[1;31mRestarting: Polybar (and killing i3bar)\e[0m"
  chmod +x $HOME/.config/polybar/scripts/fortune.sh
  killall i3bar polybar 2>/dev/null
  nohup polybar >/dev/null 2>&1 &
}

set_fortune_scripts() {
  mkdir -p $HOME/.local/bin
  mv $HOME/.config/fortuneStart $HOME/.config/fortuneStop $HOME/.local/bin/
  chmod +x $HOME/.local/bin/fortuneStart $HOME/.local/bin/fortuneStop

  mv $HOME/.config/fortuneStart.desktop $HOME/.config/fortuneStop.desktop $HOME/.local/share/applications/
}

launch_picom() {
  echo -e "\e[1;31mLaunching: Picom\e[0m"
  nohup picom >/dev/null 2>&1 &
}

launch_ws_renamer() {
  echo -e "\e[1;31mLaunching: Custom WS Renamer (Python)\e[0m"
  python3 -m pip install i3ipc
  # chmod +x $HOME/.config/polybar/scripts/launch_ws_renamer.sh
  # nohup python3 $HOME/.config/polybar/scripts/ws_renamer.py >/dev/null 2>&1 &
}

kill_terminal() {
  killall xfce4-terminal alacritty
}

varArray=('CFG_NO_WALLPAPER' 'CFG_NO_POLYBAR' 'CFG_NO_PICOM' 'CFG_NO_WS_RENAMER' 'CFG_NO_KILL_TERMINAL' 'CFG_NO_FORTUNE' 'CFG_NO_ROFI_FONTS')
varFunc=('apply_wallpaper' 'launch_polybar' 'launch_picom' 'launch_ws_renamer' 'kill_terminal' 'set_fortune_scripts' 'install_rofi_fonts')

for i in $(seq 0 $((${#varArray[@]} - 1))); do
  varname="${varArray[$i]}"
  value="${!varname}"

  if [ "$value" != "true" ]; then
    eval "${varFunc[$i]}"
  fi
done

install_python() {
mkdir ~/.venvs
python3 -m venv ~/.venvs/lvim
$HOME/.venvs/lvim/bin/pip install debugpy
}
install_python()

i3 restart ; kitty --detach ;

if [ "$CFG_NO_KILL_TERMINAL" != true ]; then kill_terminal; fi
