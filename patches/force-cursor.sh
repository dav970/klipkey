#!/bin/bash
# KlipKey Dynamic UI & Cursor Patch

CONFIG_FILE="$HOME/klipkey/klipkey.cfg"
TEMPLATE_FILE="$HOME/klipkey/klipkey.cfg.template"
# Changed to standard Klipper path
KS_CONF="$HOME/printer_data/config/KlipperScreen.conf"

if [ ! -f "$CONFIG_FILE" ]; then
    if [ -f "$TEMPLATE_FILE" ]; then
        cp "$TEMPLATE_FILE" "$CONFIG_FILE"
    fi
fi

[ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"

if [ "$pending_ks_patch" = "true" ]; then
    if [ -f "$KS_CONF" ]; then
        sed -i 's/show_cursor = .*/show_cursor = True/' "$KS_CONF"
        if ! grep -q "show_cursor" "$KS_CONF"; then
            sed -i '/\[main\]/a show_cursor = True' "$KS_CONF"
        fi
    fi
fi
