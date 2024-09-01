#!/bin/bash

# Load stuff from .env file
[ ! -f .env ] || export $(grep -v '^#' .env | xargs)


# Static Configuration
TIMESTAMP=`date "+%Y-%m-%dT%H:%M:%S"`

notify()
{
        curl -X POST -s \
                -F "title=${1}" \
                -F "message=${2}" \
                -F "priority=5" \
                "${Gotify_URL}/message?token=${Gotify_Token}"

}

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi


if ping -c 1 $IP > /dev/null 2>&1; then
  echo "$TIMESTAMP Internal network reachable." >> /var/log/wireguardtest.log
  echo "stil wrong ping"
else
  notify "Duckpond Wireguard Down" "Wireguard down, trying to fix it." > /dev/null 2>&1
  echo "$TIMESTAMP Internal network unreachable, trying to fix it." >> /var/log/wireguardtest.log
  (
    wg-quick down wg0 > /dev/null 2>&1
    wg-quick up wg0 > /dev/null 2>&1
  )
  if ping -c 1 $IP > /dev/null 2>&1; then
    echo "$TIMESTAMP Internal network reachable." >> /var/log/wireguardtest.log
    notify "Duckpond Wireguard up" "Wireguard up" > /dev/null 2>&1
  fi
fi
