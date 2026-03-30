#!/bin/bash
# KlipKey Dynamic UI & Cursor Patch

source ~/klipkey/klipkey.cfg
KS_CONF="/mnt/klipdata/config/KlipperScreen.conf"

if [ "$pending_ks_patch" = "true" ]; then
    echo "KLIPkey: Applying dynamic UI patches..."

    if [ -f "$KS_CONF" ]; then
        # --- 1. Ensure Mouse Cursor is Enabled ---
        if ! grep -q "show_cursor" "$KS_CONF"; then
            sed -i '/\[main\]/a show_cursor = True' "$KS_CONF"
        else
            sed -i 's/show_cursor = .*/show_cursor = True/' "$KS_CONF"
        fi

        # --- 2. Inject Console Button to Left Bar ---
        # This adds the button to the main navigation bar
        if ! grep -q "\[menu __main console\]" "$KS_CONF"; then
            cat <<EOF >> "$KS_CONF"

[menu __main console]
name: Console
icon: console
method: shell_command
params: /home/user/klipkey/patches/drop-to-console.sh
confirm: Are you sure you want to exit to the Launcher?
EOF
        fi
    fi

    # Reset the patch flag
    sed -i 's/^pending_ks_patch=true/pending_ks_patch=false/' ~/klipkey/klipkey.cfg
fi
