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

file=$1

if [[ -z $file ]]; then
  echo "[!] Missing the \`file\` argument"
  exit 1
fi

num_bytes=`wc -c $file | awk '{ print $1 }'`
num_lines=`wc -l $file | awk '{ print $1 }'`

num_pages_by_bytes=$(((num_bytes + 3599) / 3600))
num_pages_by_lines=$(((num_lines + 59) / 60))

if [ $num_pages_by_bytes -gt $num_pages_by_lines ]; then
  num_pages=$num_pages_by_bytes
else
  num_pages=$num_pages_by_lines
fi

new_quota=`echo "$report" | awk -v user=$current_user -v quota=$num_pages '{ if ($0 ~ user) print user, $1 + quota; else print; }'`

echo "$new_quota" > /var/lib/spool/current_report

$LP_SCRIPT "$@"
