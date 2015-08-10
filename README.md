# ddccontrol-baclkight
Bash script for linking ddccontrol to /sys/class/backlight for desktop monitors


Some monitors can have their settings (including brightness) controlled via DDC. On newer LED-backlight monitors, this can act just light the dimming for a laptop display - it's nice to turn it down for late-night reading. Unfortunately, the command-line tool to do this (ddccontrol), is totally disconnected from the normal kernel backlight driver system (using /sys/class/backlight/). I wrote a quick little hacked script that links the two.

With a little bit of fiddling and test to find the right ddccontrol commands for your monitor, you might be able to get your desktop monitor brightness to tie into any systems that normally work for laptop brightness, such as KDE or Gnome's auto-dimming stuff and keyboard shortcuts. KDE can even run this script when starting a 'power profile'.

This current implementation relies on having a non-functional backlight driver entry in /sys/class/backlight/acpi_video0, but that works on the two machines I've checked here.

This script watches changes to brightness is a /sys/class/backlight directory and calls ddccontrol to send those changes to a ddc-brightness-capable monitor.

Test out using ddccontrol first with something like
ddccontrol dev:/dev/i2c-4 -r 0x10 -w 50

If you can get ddccontrol working, modify the scrip to call ddccontrol the way that works for you.



