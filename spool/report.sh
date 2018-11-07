#!/bin/bash

report_path=/var/lib/spool/current_report

if [ -z $1 ]; then
  report_path=/var/lib/spool/current_report
elif [ ! -z $1 ]; then
  mes=$1
  ano=`date +%Y`
  if [ ! -z $2 ]; then
    ano=$2
  fi

  report_path=/var/lib/spool/backups/report-$mes-$ano.txt
fi

printf "%-20s  | %s\n" Usuário Cota
printf "=%.0s" {1..40}
printf "\n"
awk '{ printf "%-20s | %d\n", $1, $2 }' $report_path

