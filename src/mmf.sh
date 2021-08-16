#!/bin/bash

hwmon=/sys/devices/platform/applesmc.768
readonly VERSION=0.2

usage() {
  cat << EOF
Usage: ${0##*/} <cmd>
Fan speed control utility
Available commands:
SPEED                  set the fan at SPEED rpm
-t, --toggle, toggle   toggle manual speed
-v, --version          display misc infos
-h, --help             show this message
EOF
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

  echo ${tmp:=1} | tee ${hwmon}/fan1_manual

  if [[ -e ${hwmon}/fan2_manual ]]; then
    echo ${tmp:=1} | tee ${hwmon}/fan2_manual
  fi
}

write() {
    echo 1 > ${hwmon}/fan1_manual
    echo ${1/k/000} > ${hwmon}/fan1_output

    if [[ -e ${hwmon}/fan2_output ]]; then
      echo 1 > ${hwmon}/fan2_manual
      echo ${1/k/000} > ${hwmon}/fan2_output
    fi
}

case $1 in
  -t | --toggle | toggle)
    toggle
  ;;

  -h | --help)
    usage
  ;;

  -v | --version)
    infos
    exit 0
  ;;

  "")
    usage >&2
    exit 1
  ;;

  # hum assuming it is a digit lol
  *)
    write "${1/k/000}"
  ;;
esac

# vim: set ts=2 sts=2 sw=2 et :
