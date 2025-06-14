#!/bin/bash

launch_polybar() {
  echo -e "\e[1;31mRestarting: Polybar (and killing i3bar)\e[0m"
  killall i3bar polybar 2>/dev/null
  nohup polybar >/dev/null 2>&1 &
}

launch_picom() {
  echo -e "\e[1;31mLaunching: Picom\e[0m"
  nohup picom >/dev/null 2>&1 &
}

launch_polybar
launch_picom

i3 restart
