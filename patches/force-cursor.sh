#!/bin/bash
# KlipKey Dynamic UI & Cursor Patch

source ~/klipkey/klipkey.cfg
KS_CONF="/mnt/klipdata/config/KlipperScreen.conf"

# Use the current user's home path for portability
REAL_PATH="$HOME/klipkey/patches/drop-to-console.sh"

if [ "$pending_ks_patch" = "true" ]; then
    echo "KLIPkey: Applying dynamic UI patches..."

    if [ -f "$KS_CONF" ]; then
        # --- 1. Ensure Mouse Cursor is Enabled ---
        sed -i 's/show_cursor = .*/show_cursor = True/' "$KS_CONF"
        if ! grep -q "show_cursor" "$KS_CONF"; then
            sed -i '/\[main\]/a show_cursor = True' "$KS_CONF"
        fi

