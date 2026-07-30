#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
  sketchybar --set "$NAME" background.drawing=on icon.color="$FG"
else
  sketchybar --set "$NAME" background.drawing=off icon.color="$FG_DIM"
fi
