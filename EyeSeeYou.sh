#!/usr/bin/env bash

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Input
read -p "Enter the Target IP or DOMAIN: " TARGET

if [[ -z "$TARGET" ]]; then
    echo -e "${RED}Usage: $0 <domain>${NC}"
    exit 1
fi

# Log file
mkdir -p recon-$TARGET
exec > >(tee recon-$TARGET/recon.log) 2>&1

echo -e "${GREEN}[+] Starting Recon on: $TARGET${NC}"
echo

# Basic Recon
echo -e "${CYAN}[+] nslookup IP address:${NC}"
nslookup $TARGET | grep -E 'Name|Address'
echo

echo -e "${CYAN}[+] Whois information:${NC}"
whois $TARGET | grep -E 'Registrar|Registrant|Name Server|Creation Date'
echo

echo -e "${CYAN}[+] DNS Records (dig):${NC}"
dig $TARGET ANY +noall +answer
echo

echo -e "${CYAN}[+] Subdomain brute (host):${NC}"
for sub in www mail ftp admin dev test; do
    host $sub.$TARGET | grep -v "not found"
done
echo

# Passive Subdomain Enumeration
echo -e "${CYAN}[+] Running subfinder:${NC}"
subfinder -d $TARGET -silent | tee recon-$TARGET/subs.txt
echo

echo -e "${CYAN}[+] Running assetfinder:${NC}"
assetfinder --subs-only $TARGET | tee -a recon-$TARGET/subs.txt
echo

# Archived URLs
echo -e "${CYAN}[+] Getting Wayback URLs:${NC}"
cat recon-$TARGET/subs.txt | waybackurls | tee recon-$TARGET/wayback.txt
echo

# Port Scanning
echo -e "${CYAN}[+] Running Nmap quick scan:${NC}"
nmap -T4 -F $TARGET
echo

echo -e "${CYAN}[+] Running Nmap full scan (top 1000 ports):${NC}"
nmap -sV -sC -Pn $TARGET
echo


echo -e "${GREEN}[+] Recon completed. Results saved in recon-$TARGET/${NC}"
