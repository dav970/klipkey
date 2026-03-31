#!/bin/bash
# KlipKey Dynamic UI & Cursor Patch

CONFIG_FILE="$HOME/klipkey/klipkey.cfg"
TEMPLATE_FILE="$HOME/klipkey/klipkey.cfg.template"
KS_CONF="/mnt/klipdata/config/KlipperScreen.conf"

# --- 0. Ensure Config Exists ---
if [ ! -f "$CONFIG_FILE" ]; then
    echo "KLIPkey: klipkey.cfg missing. Restoring from template..."
    if [ -f "$TEMPLATE_FILE" ]; then
        cp "$TEMPLATE_FILE" "$CONFIG_FILE"
    else
        echo "KLIPkey: ERROR - Template file missing. Cannot recover config."
        exit 1
    fi
fi

# Load variables from the local config
source "$CONFIG_FILE"

if [ "$pending_ks_patch" = "true" ]; then
    echo "KLIPkey: Applying dynamic UI patches..."
    
    if [ -f "$KS_CONF" ]; then
        # Ensure Mouse Cursor is Enabled
        sed -i 's/show_cursor = .*/show_cursor = True/' "$KS_CONF"
        
        # If the line doesn't exist at all, add it under [main]
        if ! grep -q "show_cursor" "$KS_CONF"; then
            sed -i '/\[main\]/a show_cursor = True' "$KS_CONF"
        fi
    fi
fi
