#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

# $INFO is the CoreAudio output scalar, which macOS drives to 0 whenever the
# device is muted. So INFO > 0 already means "audible at INFO percent" and needs
# no lookup at all. Only 0 is ambiguous -- muted at 40% and a slider genuinely at
# 0 both report it -- and only there do we pay for the ~100ms AppleScript call,
# which still remembers the level mute will restore.
VOL="$INFO"
MUTED=false

if [ -z "$VOL" ] || [ "$VOL" -eq 0 ] 2>/dev/null; then
  read -r VOL MUTED <<<"$(osascript \
    -e 'set s to (get volume settings)' \
    -e 'return ((output volume of s) as text) & " " & ((output muted of s) as text)')"
  VOL="${VOL:-0}"
fi

if [ "$MUTED" = "true" ]; then
  ICON="$ICON_VOL_MUTE"
else
  case "$VOL" in
  [6-9][0-9] | 100) ICON="$ICON_VOL_HIGH" ;;
  *) ICON="$ICON_VOL_LOW" ;;
  esac
fi

sketchybar --set "$NAME" \
  icon="$ICON" \
  icon.color="$CYAN" \
  label="${VOL}%" \
  label.color="$FG"
