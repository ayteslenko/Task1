#!/bin/bash

echo "---Hardware---" > task4_1.out

echo "CPU: $(cat /proc/cpuinfo | grep "model name" -m1 | cut -c14- | awk '{print $1,$2,$3}')" >> task4_1.out

echo "RAM: $(grep MemTotal /proc/meminfo | cut -c17- | awk '{print $1}') KB" >> task4_1.out

baseboard_manufacturer=$(sudo dmidecode -s baseboard-manufacturer)
baseboard_product_name=$(sudo dmidecode -s baseboard-product-name)
echo "Motherboard: $baseboard_manufacturer ${baseboard_product_name:-Unknown}" | sed 's,  , ,g' >> task4_1.out

SYS_SERIAL=$(sudo dmidecode -s system-serial-number)
echo "System Serial Number: ${SYS_SERIAL:-Unknown}" >> task4_1.out

echo "---System---" >> task4_1.out

echo "OS Distribution: $(lsb_release -d --short)" >> task4_1.out

echo "Kernel version: $(uname -r)" >> task4_1.out

echo "Installation date: $(ls -ctl --full-time /etc | tail -n 1 |awk '{print $6}')" >> task4_1.out

echo "Hostname: $(hostname)" >> task4_1.out

echo "Uptime: $(uptime -p |  cut -c4-)" >> task4_1.out
# echo "Uptime: $(uptime | awk -F ', ' '{print $1}' | cut -c14-)" >> task4_1.out

echo "Processes running: $(ps -ela | sed '1d' | wc -l)" >> task4_1.out

echo "Users logged in: $(w | sed '1,2d' | wc -l)" >> task4_1.out

echo "---Network---" >> task4_1.out

for if in `ip li | grep "^[[:digit:]]" | awk -F ': ' '{print $2}'`
do ip=$(ip a sh ${if} | grep -Eo '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/[0-9]{1,2}' | tr '\n' ',' | sed 's,\,,\, ,g' | sed 's,\, $,,g')
echo  "${if}: ${ip:--}"
done >> task4_1.out
