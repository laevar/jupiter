#!/bin/bash
#
# EeePC Actions
# Andrew Wyatt
# Generic script to take actions on keypress
#

JUPITER_VAR="/var/jupiter"
JUPITER_PATH="/usr/lib/jupiter/scripts"

KERNEL_REV=$(uname -r | sed -s -e "s#-.*##" -e "s#2.6.##" -e "s#\W.*\$##")

. /usr/lib/jupiter/scripts/notify
. /etc/default/jupiter-support-eee


EEE_USER=$(who | sed -n '/ (:0[\.0]*)$\| :0 /{s/ .*//p;q}')

SELECTION=$3

if [ "$KEY_SHOW" = "1" ]; then
      notify "$SELECTION" "/usr/share/pixmaps/jupiter/jupiter.png"
fi

case $SELECTION in
  "")
    exit 0
  ;;
  $KEY_RESOLUTION)
     su $EEE_USER -l -c "DISPLAY=:0 $JUPITER_PATH/resolutions" &
  ;;
  $KEY_ROTATE)
     su $EEE_USER -l -c "DISPLAY=:0 $JUPITER_PATH/rotate" &
  ;;
  $KEY_FSB)
     $JUPITER_PATH/cpu-control &
  ;;
  $KEY_VGAOUTA)
     $JUPITER_PATH/vga-out clone &
  ;;
  $KEY_VGAOUTB)
     $JUPITER_PATH/vga-out vga &
  ;;
  $KEY_VGAOUTC)
     $JUPITER_PATH/vga-out lvds &
  ;;
  $KEY_WIFI)
     ### How dumb is it to manage devices in the kernel, rather than
     ### sending the event to the OS like more mature operating systems do.
     ### Now we have to have kludgy hacks to notify users of state changes.....
     NICON="/usr/share/pixmaps/jupiter/gnome-dev-wavelan.png"
     WIFI_STATE=$($JUPITER_PATH/wifi status)
     if [ "$WIFI_STATE" = "ON" ]; then
       notify $"WIFI Radio On" $NICON
       echo "1" >/var/jupiter/wifi-saved
     else
       notify $"WIFI Radio Off" $NICON
       echo "0" >/var/jupiter/wifi-saved
     fi
  ;;
  $KEY_PERFMON)
    notify "$KEY_PERFMON_NAME" "$KEY_PERFMON_ICON"
    su $EEE_USER -l -c "DISPLAY=:0 $KEY_PERFMON_COMMAND $KEY_PERFMON_ICON" &
  ;;
  $KEY_TOUCHPAD)
    su $EEE_USER -l -c "DISPLAY=:0 $JUPITER_PATH/touchpad" &
  ;;
  $KEY_BT)
     $JUPITER_PATH/bluetooth &
  ;;
  $KEY_CAM)
     $JUPITER_PATH/camera &
  ;;
  $KEY_CUSTOMA)
    notify "$KEY_CUSTOMA_NAME" "$KEY_CUSTOMA_ICON"
    su $EEE_USER -l -c "DISPLAY=:0 $KEY_CUSTOMA_COMMAND" &
  ;;
  $KEY_CUSTOMB)
    notify "$KEY_CUSTOMB_NAME" "$KEY_CUSTOMB_ICON"
    su $EEE_USER -l -c "DISPLAY=:0 $KEY_CUSTOMB_COMMAND" &
  ;;
  $KEY_CUSTOMC)
    notify "$KEY_CUSTOMC_NAME" "$KEY_CUSTOMC_ICON"
    su $EEE_USER -l -c "DISPLAY=:0 $KEY_CUSTOMC_COMMAND" &
  ;;
  $KEY_CUSTOMD)
    notify "$KEY_CUSTOMD_NAME" "$KEY_CUSTOMD_ICON"
    su $EEE_USER -l -c "DISPLAY=:0 $KEY_CUSTOMD_COMMAND" &
  ;;
esac
