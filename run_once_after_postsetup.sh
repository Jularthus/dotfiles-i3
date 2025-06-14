#!/bin/bash

if [ -f $HOME/.cfg2 ]; then
  exit
fi

touch $HOME/.cfg2

launch_polybar() {
  echo -e "\e[1;31mRestarting: Polybar (and killing i3bar)\e[0m"
  chmod +x $HOME/.config/polybar/scripts/fortune.sh
  killall i3bar polybar 2>/dev/null
  nohup polybar >/dev/null 2>&1 &
}

launch_picom() {
  echo -e "\e[1;31mLaunching: Picom\e[0m"
  nohup picom >/dev/null 2>&1 &
}

launch_ws_renamer() {
  echo -e "\e[1;31mLaunching: Custom WS Renamer (Python)\e[0m"
  python3 -m pip install i3ipc
  nohup python3 $HOME/.config/polybar/scripts/ws_renamer.py >/dev/null 2>&1 &
}

kill_terminal() {
  killall xfce4-terminal alacritty
}

launch_polybar
launch_picom
launch_ws_renamer
i3 restart ; kitty --detach ;
kill_terminal
