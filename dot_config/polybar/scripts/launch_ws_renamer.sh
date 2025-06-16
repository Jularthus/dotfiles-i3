#!/usr/bin/env bash

pkill -f ws_renamer.py
python3 "$HOME/.config/polybar/scripts/ws_renamer.py" >> "$HOME/ws_renamer.log" 2>&1 &
# python3 $HOME/.config/polybar/scripts/ws_renamer.py
