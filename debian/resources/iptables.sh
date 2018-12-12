#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

. ./config.sh
. ./colors.sh

#send a message
verbose "Configuring IPTables"

#run iptables commands
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -j DROP -p udp --dport 5060:5091 -m string --string "friendly-scanner" --algo bm
iptables -A INPUT -j DROP -p tcp --dport 5060:5091 -m string --string "friendly-scanner" --algo bm
iptables -A INPUT -j DROP -p udp --dport 5060:5091 -m string --string "sipcli/" --algo bm
iptables -A INPUT -j DROP -p tcp --dport 5060:5091 -m string --string "sipcli/" --algo bm
iptables -A INPUT -j DROP -p udp --dport 5060:5091 -m string --string "VaxSIPUserAgent/" --algo bm
iptables -A INPUT -j DROP -p tcp --dport 5060:5091 -m string --string "VaxSIPUserAgent/" --algo bm
iptables -A INPUT -j DROP -p udp --dport 5060:5091 -m string --string "pplsip" --algo bm
iptables -A INPUT -j DROP -p tcp --dport 5060:5091 -m string --string "pplsip" --algo bm
iptables -A INPUT -j DROP -p udp --dport 5060:5091 -m string --string "script" --algo bm
iptables -A INPUT -j DROP -p tcp --dport 5060:5091 -m string --string "script" --algo bm
iptables -A INPUT -j DROP -p udp --dport 5060:5091 -m string --string "exec." --algo bm
iptables -A INPUT -j DROP -p tcp --dport 5060:5091 -m string --string "exec." --algo bm
iptables -A INPUT -j DROP -p udp --dport 5060:5091 -m string --string "system" --algo bm
iptables -A INPUT -j DROP -p tcp --dport 5060:5091 -m string --string "system" --algo bm
iptables -A INPUT -j DROP -p sip --dport 5060:5091 -m string --string "multipart/mixed;boundary" --algo bm
iptables -A INPUT -j DROP -p tcp --dport 5060:5091 -m string --string "multipart/mixed;boundary" --algo bm
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -p tcp --dport 7443 -j ACCEPT
iptables -A INPUT -p tcp --dport 5060:5091 -j ACCEPT
iptables -A INPUT -p udp --dport 5060:5091 -j ACCEPT
iptables -A INPUT -p udp --dport 16384:32768 -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
iptables -A INPUT -p udp --dport 1194 -j ACCEPT
iptables -t mangle -A OUTPUT -p udp -m udp --sport 16384:32768 -j DSCP --set-dscp 46
iptables -t mangle -A OUTPUT -p udp -m udp --sport 5060:5091 -j DSCP --set-dscp 26
iptables -t mangle -A OUTPUT -p tcp -m tcp --sport 5060:5091 -j DSCP --set-dscp 26
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

#answer the questions for iptables persistent
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
apt-get install -y --force-yes  iptables-persistent
