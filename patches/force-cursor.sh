#!/bin/bash
# KlipKey Event-Driven Boot Patch & Menu Injector

source ~/klipkey/klipkey.cfg
KS_CONF="/mnt/klipdata/config/KlipperScreen.conf"

if [ "$pending_ks_patch" = "true" ]; then
    echo "KLIPkey: Post-install patch triggered..."

    if [ -f "$KS_CONF" ]; then
        # --- 1. Force Cursor Visibility ---
        if ! grep -q "show_cursor" "$KS_CONF"; then
            sed -i '/\[main\]/a show_cursor = True' "$KS_CONF"
        else
            sed -i 's/show_cursor = .*/show_cursor = True/' "$KS_CONF"
        fi

        # --- 2. Inject Console Button to Left Bar ---
        # We define a custom menu item that calls our script
        if ! grep -q "\[menu __main console\]" "$KS_CONF"; then
            cat <<EOF >> "$KS_CONF"

[menu __main console]
name: Console
icon: console
method: shell_command
params: /home/user/klipkey/patches/drop-to-console.sh
confirm: Are you sure you want to drop to Console?
EOF
        fi
    fi

    # Reset the flag in klipkey.cfg
    sed -i 's/^pending_ks_patch=true/pending_ks_patch=false/' ~/klipkey/klipkey.cfg
    echo "Patch Applied: KlipperScreen cursor and Console button restored."
fi
