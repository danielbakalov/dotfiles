#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

BATT=$(pmset -g batt)
PCT=$(echo "$BATT" | grep -Eo '[0-9]+%' | tr -d '%')
CHARGING=$(echo "$BATT" | grep -c 'AC Power')

[ -z "$PCT" ] && exit 0

COLOR="$FG"
case "$PCT" in
100 | 9[0-9] | 8[0-9] | 7[0-9]) ICON="$ICON_BAT_100" ;;
6[0-9] | 5[0-9]) ICON="$ICON_BAT_75" ;;
4[0-9] | 3[0-9]) ICON="$ICON_BAT_50" ;;
2[0-9] | 1[0-9])
  ICON="$ICON_BAT_25"
  COLOR="$YELLOW"
  ;;
*)
  ICON="$ICON_BAT_0"
  COLOR="$RED"
  ;;
esac

if [ "$CHARGING" -ne 0 ]; then
  ICON="$ICON_CHARGING"
  COLOR="$GREEN"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="${PCT}%"
