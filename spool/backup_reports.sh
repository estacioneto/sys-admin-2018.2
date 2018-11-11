#!/bin/bash

backup_filepath="/var/lib/spool/backup/report-$(date +%m-%Y).txt"
current_report_path="/var/lib/spool/current_report"

quota=`cat /var/lib/spool/quota`
new_report=`awk -v quota=$quota '{ new_quota = $2 - quota; print $1, (new_quota < 0) ? 0 : new_quota; }' $current_report_path`

mv $current_report_path $backup_filepath && echo -e "$new_report" > $current_report_path && chmod -w $backup_filepath

