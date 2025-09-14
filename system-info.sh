#!/bin/bash

# This is for class but i'm putting it here because it seems useful and i was going stupid with awk

echo -e "\n----\tTIME\t----"
date=$(date)
uptime=$(uptime)
:
printf "[+] Date: %s\n[+] Uptime: %s\n" "$date" "$uptime"  

echo -e "\n----\tOS\t----"
cpu=$(lscpu | awk -F: '/^Model name:/ { gsub(/ /, ""); print $2}')
os=$(awk -F= '/^PRETTY_NAME=/ {gsub(/"/, "", $2); print $2}' /etc/os-release)
krn=$(uname -r)

printf "[+] CPU: %s\n[+] OS: %s\n[+] Kernel: %s\n" "$cpu" "$os" "$krn"

echo -e "\n----\tSYSTEM\t----"
arch=$(lscpu | awk -F: '/^Architecture/ {gsub(/ /, ""); print $2}')
mem=$(free -h | awk 'NR==2 {print "Total "$2 ", Used " $3 ", Free "$4 ", Available "$7}')
df=$(df -h | awk '$6=="/" {print "Disk " $1 ", Size " $2 ", Used " $3 ", Mounted on " $6}')
hostname=$(hostname)
domain=$(hostname -d)

printf "[+] Architecture: %s\n[+] Memory: %s\n[+] Filesystem: %s\n[+] Partitions: \n%s\n[+] Hostname: %s\n[+] Domain: %s" "$arch" "$mem" "$df" "$(lsblk)" "$hostname" "$domain"

echo -e "\n"
