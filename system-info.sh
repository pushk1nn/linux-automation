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

printf "[+] Architecture: %s\n[+] Memory: %s\n[+] Filesystem: %s\n[+] Partitions: \n%s\n[+] Hostname: %s\n[+] Domain: %s\n" "$arch" "$mem" "$df" "$(lsblk)" "$hostname" "$domain"

echo -e "\n----\tNETWORKING\t----"

mac=$(ip -c a | awk '/^[0-9]+:/ {gsub(/:/, "", $2); iface=$2 } /link\/ether/ {print iface, $2}')
ip=$(ip -c a | awk '/^[0-9]+:/ {gsub(/:/, "", $2); iface=$2 } $1=="inet" {gsub(/\/[0-9]{1,2}/, "", $2); print iface, $2}')
promisc=$(ip -d link show | awk '/^[0-9]+:/ {gsub(/:/, "", $2); iface=$2 } match($0, /\<promiscuity\>[[:space:]]+([0-9]+)/, arr) {print iface, "is",  arr[1]==0 ? "not" : "\b", "promiscuous"}')
connections=$(netstat -an | awk 'NR==2 {print} /\<ESTABLISHED\>/ {print}' )

printf "[+] MAC: \n%s\n[+] IP: \n%s\n[+] Promiscuous?: \n%s\n[+] Connections: \n%s\n" "$mac" "$ip" "$promisc" "$connections"

echo -e "\n----\tUSERS\t----"

current_users=$(who)
login_history=$(last -n 30)
users_pid_0=$(awk -F: '($3 == 0) {print $1}' /etc/passwd)
root_suid=$(find / -uid 0 -perm -4000 -type f 2>/dev/null)

printf "[+] Current Users: \n%s\n[+] Login History (30 entries): \n%s\n[+] PID 0 Users: \n%s\n[+] Root SUID Files: \n%s\n" "$current_users" "$login_history" "$users_pid_0" "$root_suid"

echo -e "\n----\tPROCESSES\t----"

ps=$(ps -ef --forest)
nc=$(lsof -c nc)
del=$(lsof +L1)

printf "[+] All Processes: \n%s\n[+] Files Opened by nc: \n%s\n[+] Deleted Files: \n%s\n" "$ps" "$nc" "$del" 

echo -e "\n----\tPROCESSES\t----"

mod=$(find ~ -type f -mtime -1)
cron=$(crontab -u root -l)
bashrc=$(cat ~/.bashrc)
keys=$(cat ~/.ssh/authorized_keys)
bins=$(find /bin /sbin /usr/bin /usr/sbin -type f -mtime -2)

printf "[+] Modified Files (Home): \n%s\n[+] Modified Files (System Binaries): \n%s\n[+] Root Cronjobs: \n%s\n[+] User .bashrc: \n%s\n [+] Authorized SSH Keys: \n%s\n" "$mod" "$bins" "$cron" "$bashrc" "$keys" 
