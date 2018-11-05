#!/bin/bash

backup_filepath="/var/lib/spool/backup/$(date +%m-%Y)"
current_report_path="/var/lib/spool/current_report"

mv $current_report_path $backup_filepath && touch $current_report_path && chmod -w $backup_filepath

