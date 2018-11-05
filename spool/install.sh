#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo -e "\033[0;31mPlease run as root\033[0m" >&2
  exit
fi

limit=30

while getopts ":l:" opt; do
  case $opt in
    l)
      limit=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done

usuarios=`cat /etc/passwd | grep -v -E '(nologin|false|sync)' | cut -d ':' -f1`

# criar diretorio /var/lib/spooler
mkdir -p /var/lib/spooler

# renomear script de `lp`
lp_location=`which lp`

if [ -z "$lp_location" ]; then
  echo -e "The script `lp` was not found" &>2
  exit 1
fi

# instalar nosso script de `lp`

# instalar crontab

# instalar script de relatório
