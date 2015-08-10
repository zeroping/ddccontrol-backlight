#!/bin/bash

# This script watches changes to brightness is a /sys/class/backlight directory 
# and calls ddccontrol to send those changes to a ddc-brightness-capable monitor.

# Test out using ddccontrol first with something like
# ddccontrol dev:/dev/i2c-4 -r 0x10 -w 50

# Modify this function as needed to handle setting your monitor brightness
function ddcset {
  ddccontrol dev:/dev/i2c-4 -r 0x10 -w $1 1>&2 > /dev/null
}  

# On my machine, there's a (non-functional) entry in /sys/class/backlight, so
# we watch those entyries for changes comming from whatever GUI tool.
brightnessdir="/sys/class/backlight/acpi_video0"

### actual implementation

#set to 101 to guarentee changes on first run
currddcbrt=101

curbrt=$( cat $brightnessdir/brightness )
maxbrt=$( cat $brightnessdir/max_brightness )

ddcbrt=$(( curbrt * 100 / maxbrt ))

while (true); do
  curbrt=$( cat $brightnessdir/brightness )
  ddcbrt=$(( curbrt * 100 / maxbrt ))
  
  if [[ $currddcbrt != $ddcbrt ]]
  then
    currddcbrt=$ddcbrt
    echo "setting to $ddcbrt"
    ddcset $ddcbrt
  else
    echo "no update needed"
  fi
  inotifywait $brightnessdir/brightness 1>&2 > /dev/null
  # we sleep here to avoid calling ddccontrol really really often
  sleep 1
done 