#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo -e "\033[0;31mPlease run as root\033[0m" >&2
  exit
fi

usage="Usage: $(basename "$0") [-h] [-l n]

Options:
\t-h    Show this help text
\t-l n  Set the limit page quota of each user"

print_help() {
  echo -e "$usage"
}

user_quota_limit=30

while getopts ":hl:" opt; do
  case $opt in
    l)
      user_quota_limit=$OPTARG
      ;;
    h)
      print_help
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      print_help
      exit 1
      ;;
  esac
done

users=`cat /etc/passwd | grep -v -E '(nologin|false|sync)' | cut -d ':' -f1`

# cria diretorios em /var/lib/spool
mkdir -p /var/lib/spool

mkdir -p /var/lib/spool/backup

# salva cota e usuários
echo $user_quota_limit > /var/lib/spooler/quota
echo $users > /var/lib/spooler/users

chmod -w /var/lib/spooler/quota

# renomeia script de `lp` com permissões restritas
lp_location=`which lp`
lp_new_script="lp.orig"

if [ -z "$lp_location" ]; then
  echo -e "The binary file \`lp\` was not found" &>2
  exit 1
fi

base_dir=`dirname $lp_location`

mv $lp_location "$base_dir/$lp_new_script"
ln -s "$base_dir/$lp_new_script"

chmod 744 "$base_dir/$lp_new_script"

# instala nosso script de `lp` com permissão de root em execução
mv "print.sh" $lp_location

chmod u+s $lp_location

# instalar crontab
crontab -l > custom_cron 2> /dev/null
cat crontab >> custom_cron
crontab custom_cron
rm custom_cron

backup_script_name="lp_backup"
mv "backup_reports.sh" "$base_dir/$backup_script_name"

# instala script de relatório com permissão de root em execução
report_script_name="lp_report"

mv "report.sh" "$base_dir/$report_script_name"

chmod u+s "$base_dir/$report_script_name"

