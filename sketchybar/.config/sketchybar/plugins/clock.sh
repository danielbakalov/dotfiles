#!/usr/bin/env bash

# %l pads single-digit hours with a space; strip it so " 3:20 PM" reads "3:20 PM".
TIME="$(date '+%l:%M %p')"

sketchybar --set "$NAME" label="$(date '+%a %d %b')  ${TIME# }"
