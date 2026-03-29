#!/bin/bash
# KlipKey Event-Driven Boot Patch

# Load config to get the flag
source ~/klipkey/klipkey.cfg

KS_CONF="/mnt/klipdata/config/KlipperScreen.conf"
GREEN='\033[0;32m'
NC='\033[0m'

# Check if a patch is actually pending
if [ "$pending_ks_patch" = "true" ]; then
    echo -e "${GREEN}KLIPkey: Post-install patch triggered...${NC}"
    
    if [ -f "$KS_CONF" ]; then
        # Ensure [main] section exists
        if ! grep -q "\[main\]" "$KS_CONF"; then
            echo -e "[main]\nshow_cursor = True" >> "$KS_CONF"
        elif ! grep -q "show_cursor" "$KS_CONF"; then
            sed -i '/\[main\]/a show_cursor = True' "$KS_CONF"
        else
            sed -i 's/show_cursor = .*/show_cursor = True/' "$KS_CONF"
        fi
        
        # Reset the flag in klipkey.cfg so it doesn't run again next boot
        sed -i 's/^pending_ks_patch=true/pending_ks_patch=false/' ~/klipkey/klipkey.cfg
        echo -e "Patch Applied: KlipperScreen cursor restored."
    fi
else
    # No patch pending; silent exit to speed up boot
    exit 0
fi
