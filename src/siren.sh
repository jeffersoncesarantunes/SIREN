#!/usr/bin/env bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${RED}🚨 S.I.R.E.N. - Forensic Memory Streamer${NC}"
echo "------------------------------------------"

if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}[!] Error: This script must be run as root.${NC}"
   exit 1
fi

map_system_ram() {
    echo -e "${GREEN}[+] Mapping safe System RAM regions...${NC}"
    echo "--------------------------------------------------------"
    grep "System RAM" /proc/iomem | while read -r line; do
        range=$(echo $line | cut -d' ' -f1)
        echo -e "Address: ${YELLOW}$range${NC} [SAFE RANGE]"
    done
    echo "--------------------------------------------------------"
}

stream_analysis() {
    local source=$1
    local output_dir="../dumps"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    
    mkdir -p "$output_dir"
    
    echo -e "${YELLOW}[!] Starting acquisition from:${NC} $source"
    echo "[!] Results will be saved to: $output_dir"
    
    cat "$source" | tee >(sha256sum > "$output_dir/dump_$timestamp.sha256") \
                  | strings > "$output_dir/strings_$timestamp.txt"

    echo -e "${GREEN}[+] Pipeline completed successfully.${NC}"
}

echo -e "1) Map Memory (iomem)"
echo -e "2) Test Forensic Pipeline (/proc/version)"
echo -e "3) Exit"
read -p "Select an option: " opt

case $opt in
    1)
        map_system_ram
        ;;
    2)
        stream_analysis "/proc/version"
        ;;
    3)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Invalid option."
        ;;
esac
