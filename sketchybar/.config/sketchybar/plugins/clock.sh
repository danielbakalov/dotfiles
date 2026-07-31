#!/usr/bin/env bash

TIME="$(date '+%l:%M %p')"

sketchybar --set "$NAME" label="$(date '+%a %d %b')  ${TIME# }"
