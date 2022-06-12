#!/bin/sh

# $1 - first argument is time to show notification 
# $2 - second argument define the battery critical level. If the battery is under battery critical level notify user

[ -z $2 ] && battery_critical_level=15|| battery_critical_level=$2

battery_capacity=$(cat "/sys/class/power_supply/BAT1/capacity") # get battery capacity in percentage
battery_capacity_status=$(cat "/sys/class/power_supply/BAT1/status") # get battery status
  
# if battery is under 15% and battery is not charging notify user about it
[ "$battery_capacity" -lt $battery_critical_level ] && [ $battery_capacity_status != "Charging" ] && ( [ -z $1 ] \
  && notify-send -u critical -t 10000 "Low battery." \
  || notify-send -u critical -t $1 "Low battery.")

echo "$battery_capacity_status" "$battery_capacity"
