#!/bin/bash
# KlipKey Dynamic UI & Cursor Patch

# Changed to standard Klipper path
KS_CONF="$HOME/printer_data/config/KlipperScreen.conf"

if [ -f "$KS_CONF" ]; then
    sed -i 's/show_cursor = .*/show_cursor = True/' "$KS_CONF"
    if ! grep -q "show_cursor" "$KS_CONF"; then
        sed -i '/\[main\]/a show_cursor = True' "$KS_CONF"
    fi
fi
