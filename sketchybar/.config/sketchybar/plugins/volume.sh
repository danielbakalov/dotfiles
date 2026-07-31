#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

VOL="$INFO"
MUTED=false

if [ -z "$VOL" ] || [ "$VOL" -eq 0 ] 2>/dev/null; then
  read -r VOL MUTED <<<"$(osascript \
    -e 'set s to (get volume settings)' \
    -e 'return ((output volume of s) as text) & " " & ((output muted of s) as text)')"
  VOL="${VOL:-0}"
fi

read -r TRANSPORT DEVICE <<<"$(system_profiler SPAudioDataType 2>/dev/null | awk '
  function flush() { if (isdef && name != "") { print transport, name; exit } }
  /^ {8}[^ ].*:$/ {
    flush()
    name = $0; sub(/^ +/, "", name); sub(/:$/, "", name)
    isdef = 0; transport = "-"
    next
  }
  /Default Output Device: Yes/ { isdef = 1 }
  /Transport:/ { transport = $2 }
  END { flush() }
')"

HEADPHONES=false
case "$DEVICE" in
*[Hh]eadphone* | *[Hh]eadset* | *AirPods*) HEADPHONES=true ;;
esac

if [ "$HEADPHONES" = false ] && [ "$TRANSPORT" = "Bluetooth" ]; then
  MINOR=$(system_profiler SPBluetoothDataType 2>/dev/null | awk -v dev="$DEVICE" '
    /^ *Connected:/ { conn = 1; next }
    /^ *Not Connected:/ { conn = 0 }
    conn && /^ {10}[^ ].*:$/ {
      name = $0; sub(/^ +/, "", name); sub(/:$/, "", name)
      cur = (name == dev)
    }
    cur && /Minor Type:/ { print $3; exit }
  ')
  case "$MINOR" in
  Headphones | Headset) HEADPHONES=true ;;
  esac
fi

if [ "$MUTED" = "true" ]; then
  ICON="$ICON_VOL_MUTE"
elif [ "$HEADPHONES" = true ]; then
  ICON="$ICON_HEADPHONES"
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
