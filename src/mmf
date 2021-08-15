#!/bin/bash

hwmon=/sys/devices/platform/applesmc.768

usage() {
  cat << EOF
Usage: ${0##*/} <cmd>
Fan speed control utility
Available commands:
SPEED                  set the fan at SPEED rpm
-t, --toggle, toggle   toggle manual speed
-h, --help             show this message
EOF
}

toggle() {
  local tmp

  [[ $(< ${hwmon}/fan1_manual) = 1 ]] && tmp=0
  echo ${tmp:=1} | tee ${hwmon}/fan1_manual

  [[ -f ${hwmon}/fan2_manual ]] && \
  echo ${tmp} | tee ${hwmon}/fan2_manual
}

case $1 in
  -t | --toggle | toggle)
    toggle
  ;;

  -h | --help)
    usage
  ;;

  "")
    usage >&2
    exit 1
  ;;

  # hum assuming it is a digit lol
  *)
    [[ $(< ${hwmon}/fan1_manual) != 1 ]] && echo 1 > ${hwmon}/fan1_manual
    echo ${1/k/000} > ${hwmon}/fan1_output

    [[ -f ${hwmon}/fan2_output ]] && \
    echo ${1/k/000} > ${hwmon}/fan2_output
  ;;
esac

# vim: set ts=2 sts=2 sw=2 et :
