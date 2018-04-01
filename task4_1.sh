#!/bin/bash

WRK_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUT_FILE=${WRK_DIR}/task4_1.out

echo "---Hardware---" > ${OUT_FILE}

echo "CPU: $(cat /proc/cpuinfo | grep "model name" -m1 | cut -c14- | awk '{print $1,$2,$3}')" >> ${OUT_FILE}

echo "RAM: $(grep MemTotal /proc/meminfo | cut -c17- | awk '{print $1}') KB" >> ${OUT_FILE}

baseboard_manufacturer=$(sudo dmidecode -s baseboard-manufacturer)
baseboard_product_name=$(sudo dmidecode -s baseboard-product-name)
echo "Motherboard: $baseboard_manufacturer ${baseboard_product_name:-Unknown}" | sed 's,  , ,g' >> ${OUT_FILE}

SYS_SERIAL=$(sudo dmidecode -s system-serial-number)
echo "System Serial Number: ${SYS_SERIAL:-Unknown}" >> ${OUT_FILE}

echo "---System---" >> ${OUT_FILE}

echo "OS Distribution: $(lsb_release -d --short)" >> ${OUT_FILE}

echo "Kernel version: $(uname -r)" >> ${OUT_FILE}

echo "Installation date: $(ls -ctl --full-time /etc | tail -n 1 |awk '{print $6}')" >> ${OUT_FILE}

echo "Hostname: $(hostname)" >> ${OUT_FILE}

echo "Uptime: $(uptime -p |  cut -c4-)" >> ${OUT_FILE}
# echo "Uptime: $(uptime | awk -F ', ' '{print $1}' | cut -c14-)" >> ${OUT_FILE}

echo "Processes running: $(ps -ela | sed '1d' | wc -l)" >> ${OUT_FILE}

echo "Users logged in: $(w | sed '1,2d' | wc -l)" >> ${OUT_FILE}

echo "---Network---" >> ${OUT_FILE}

for if in `ip li | grep "^[[:digit:]]" | awk -F ': ' '{print $2}'`
do ip=$(ip a sh ${if} | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}' | tr '\n' ',' | sed 's,\,,\, ,g' | sed 's,\, $,,g')
echo  "${if}: ${ip:--}"
done >> ${OUT_FILE}
