#!/bin/sh

# echo " $(xbacklight -get)%"# did work fine on manjaro but doesn't work so good on arch linux
echo " $(xbacklight -get | cut -d '.' -f 1)%"
# icon: \ue9d6
