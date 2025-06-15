#!/bin/bash

map_icon() {
    case "$1" in
        Firefox) echo "" ;;
        Alacritty|kitty) echo "" ;;
        *) echo "" ;; # default
    esac
}

i3-msg -t get_tree | jq -r '
  recurse(.nodes[]?) | 
  select(.window_properties != null) | 
  "\(.workspace),\(.window_properties.class)"
' | while IFS=, read -r ws app; do
    icon=$(map_icon "$app")
    echo -n "$icon "
done
