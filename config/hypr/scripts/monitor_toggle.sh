#!/bin/bash

external_monitor=$(hyprctl monitors | grep "HDMI-A-1")

if [[ -n "$external_monitor" ]]; then
  echo "External monitor detected, disabling laptop display"
  hyprctl keyword monitor "eDP-1, disable"
  hyprctl keyword monitor "HDMI-A-1, preferred, auto, 1"
else
  echo "No external monitor detected, enabling laptop display"
  hyprctl keyword monitor "eDP-1, preferred, auto, 1.25"
fi
