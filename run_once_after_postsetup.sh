#!/bin/bash

if [ -f $HOME/.cfg2 ]; then
  exit
fi

touch $HOME/.cfg2

source /tmp/cfg_profile

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

varArray=('CFG_NO_POLYBAR' 'CFG_NO_PICOM' 'CFG_NO_WS_RENAMER' 'CFG_NO_KILL_TERMINAL' 'CFG_NO_FORTUNE')
varFunc=('launch_polybar' 'launch_picom' 'launch_ws_renamer' 'kill_terminal' 'set_fortune_scripts')

for i in $(seq 0 $((${#varArray[@]} - 1))); do
  varname="${varArray[$i]}"
  value="${!varname}"

  if [ "$value" != "true" ]; then
    eval "${varFunc[$i]}"
  fi
done

i3 restart ; kitty --detach ;

if [ "$CFG_NO_KILL_TERMINAL" != true ]; then kill_terminal; fi
