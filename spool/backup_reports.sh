#!/bin/bash

backup_filepath="/var/lib/spool/backup/report-$(date +%m-%Y).txt"
current_report_path="/var/lib/spool/current_report"

# TODO: Quota definition logic

mv $current_report_path $backup_filepath && touch $current_report_path && chmod -w $backup_filepath

