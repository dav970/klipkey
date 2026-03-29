#!/bin/bash
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

SERVICES=("klipper" "moonraker" "KlipperScreen" "crowsnest")

while true; do
    clear
    echo "====================================="
    echo "    SERVICE CONTROL (TOGGLE)"
    echo "====================================="
    for i in "${!SERVICES[@]}"; do
        SERVICE=${SERVICES[$i]}
        STATE=$(systemctl is-active "$SERVICE" 2>/dev/null)
        if ! systemctl list-unit-files | grep -q "^$SERVICE.service"; then
            printf "  [%d] %-18s ${YELLOW}[ MISSING ]${NC}\n" "$((i+1))" "$SERVICE"
        elif [ "$STATE" = "active" ]; then
            printf "  [%d] %-18s ${GREEN}[ RUNNING ]${NC}\n" "$((i+1))" "$SERVICE"
        elif [ "$STATE" = "activating" ]; then
            printf "  [%d] %-18s ${CYAN}[ STARTING ]${NC}\n" "$((i+1))" "$SERVICE"
        else
            printf "  [%d] %-18s ${RED}[ STOPPED ]${NC}\n" "$((i+1))" "$SERVICE"
        fi
    done
    echo "====================================="
    echo "  [ B ] Back to Main Menu"
    echo "-------------------------------------"
    read -n 1 -s -p "Select # to Toggle: " choice
    case $choice in
        [Bb]) exit 0 ;;
        [1-4])
            INDEX=$((choice-1))
            SERVICE=${SERVICES[$INDEX]}
            if systemctl is-active --quiet "$SERVICE"; then
                sudo systemctl stop "$SERVICE"
            else
                sudo systemctl start "$SERVICE"
            fi ;;
    esac
done
