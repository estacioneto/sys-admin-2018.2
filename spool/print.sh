#!/bin/bash

LP_SCRIPT=/usr/bin/lp.orig

quota=`cat /var/lib/spool/quota`
current_user=`whoami`
report=`cat /var/lib/spool/current_report`

current_quota=`echo "$report" | awk -v user=$current_user '$0 ~ user { print $2 }'`

if [ $current_quota -ge $quota ]; then
  echo "[!] You've exceeded you quota limit for this month"
  exit 1
fi

# TODO: update quota

$LP_SCRIPT "$@"
