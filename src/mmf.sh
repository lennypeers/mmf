#!/bin/bash

readonly VERSION=0.2.3 hwmon=/sys/devices/platform/applesmc.768

usage() {
  cat << EOF
Usage: ${0##*/} <cmd>
Fan speed control utility
Available commands:
SPEED                  set the fan at SPEED rpm
                       SPEED between 0 and 6500
-a, --auto             set the fan in auto control
-m, --manual           set the fan in manual control
-t, --toggle, toggle   toggle manual speed
-v, --version          display misc infos
-h, --help             show this message
-i, --inc N            increase of N (integer)
-d, --dec N            decrease of N (integer)
EOF

  exit ${1:-0}
}

infos() {
  cat << EOF
mmf v${VERSION}
MIT License
Copyright (c) 2021 lennypeers
EOF
}

toggle() {
  local tmp

  if [[ $(cat ${hwmon}/fan1_manual) = 1 ]]; then
    tmp=0
  fi

  echo $tmp > ${hwmon}/fan2_manual
  echo ${tmp:=1} > ${hwmon}/fan1_manual || return 1

  echo $tmp # so the user knows the current state
}

write_control() {
  echo "$1" > ${hwmon}/fan2_manual
  echo "$1" > ${hwmon}/fan1_manual || return 1
}

write_speed() {
  echo $1 > ${hwmon}/fan2_output
  echo $1 > ${hwmon}/fan1_output || return 1
}

error_perms() {
  cat >&2 << EOF
Cannot write to devices.
If freshly installed reboot to run the udev rules.
Else, wtf?
EOF
  exit 3
}

case $1 in
  -t | --toggle | toggle)
    toggle 2>/dev/null || error_perms
  ;;

  -h | --help)
    usage
  ;;

  -v | --version)
    infos
  ;;

  -a | --auto)
    write_control 0  2>/dev/null || error_perms
  ;;

  -m | --manual)
    write_control 1  2>/dev/null || error_perms
  ;;

  -i | --inc)
    shift
    val="$1" l=$(cat ${hwmon}/fan1_output)
    l=$((l+val))
    write_control 1  2>/dev/null || error_perms
    write_speed "$l" 2>/dev/null || usage 1 >&2
  ;;

  -d | --dec)
    shift
    val="$1" l=$(cat ${hwmon}/fan1_output)
    l=$((l-val))
    write_control 1  2>/dev/null || error_perms
    write_speed "$l" 2>/dev/null || usage 1 >&2
  ;;

  *) # SPEED
    write_control 1  2>/dev/null || error_perms
    write_speed "$1" 2>/dev/null || usage 1 >&2
  ;;
esac

# vim: set ts=2 sts=2 sw=2 et :
