#!/usr/bin/env bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${GREEN}🐧 S.I.R.E.N. - Forensic Memory Streamer${NC}"
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
    
    if [[ "$source" == "/dev/mem" ]]; then
        echo -e "${RED}[!] WARNING: Reading physical RAM. System freeze possible.${NC}"
        dd if="$source" bs=1M count=100 2>/dev/null | tee >(sha256sum > "$output_dir/mem_dump_$timestamp.sha256") \
                                                   | strings > "$output_dir/mem_strings_$timestamp.txt"
    else
        cat "$source" | tee >(sha256sum > "$output_dir/dump_$timestamp.sha256") \
                      | strings > "$output_dir/strings_$timestamp.txt"
    fi

    echo -e "${GREEN}[+] Pipeline completed successfully.${NC}"
}

automated_extraction() {
    local output_dir="../dumps"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    mkdir -p "$output_dir"

    echo -e "${YELLOW}[!] Starting Automated Safe Range Extraction...${NC}"
    
    grep "System RAM" /proc/iomem | while read -r line; do
        range=$(echo $line | cut -d' ' -f1)
        start_hex=$(echo $range | cut -d'-' -f1)
        end_hex=$(echo $range | cut -d'-' -f2)
        
        start_dec=$((16#$start_hex))
        end_dec=$((16#$end_hex))
        size=$((end_dec - start_dec))
        
        echo -e "${GREEN}[+] Extracting: $start_hex ($size bytes)${NC}"
        
        dd if=/dev/mem bs=1 skip=$start_dec count=$size 2>/dev/null >> "$output_dir/full_mem_scan_$timestamp.bin"
    done

    echo -e "${YELLOW}[*] Generating strings and hash for full scan...${NC}"
    sha256sum "$output_dir/full_mem_scan_$timestamp.bin" > "$output_dir/full_mem_scan_$timestamp.sha256"
    strings "$output_dir/full_mem_scan_$timestamp.bin" > "$output_dir/full_mem_scan_$timestamp.txt"

    echo -e "${GREEN}[+] Automated scan finished. Results in $output_dir${NC}"
}

echo -e "1) Map Memory (iomem)"
echo -e "2) Test Pipeline (/proc/version)"
echo -e "3) Live Memory Extraction (DANGEROUS)"
echo -e "4) Automated Safe Scan (BETA)"
echo -e "5) Exit"
read -p "Select an option: " opt

case $opt in
    1) map_system_ram ;;
    2) stream_analysis "/proc/version" ;;
    3)
        echo -e "${RED}⚠️  ACTION REQUIRED: To prevent system freezing, ignore reserved ranges.${NC}"
        read -p "Continue with 100MB sample from /dev/mem? (y/n): " confirm
        [[ $confirm == "y" ]] && stream_analysis "/dev/mem"
        ;;
    4) automated_extraction ;;
    5) exit 0 ;;
    *) echo "Invalid option." ;;
esac
