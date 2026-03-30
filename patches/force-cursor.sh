#!/bin/bash
# KlipKey Event-Driven Boot Patch & UI Injector

source ~/klipkey/klipkey.cfg
KS_CONF="/mnt/klipdata/config/KlipperScreen.conf"
KS_PANEL_DIR="$HOME/KlipperScreen/panels"
PATCH_SRC="$HOME/klipkey/patches/shutdown.py"

if [ "$pending_ks_patch" = "true" ]; then
    echo "KLIPkey: Post-install patch triggered..."

    # 1. Patch the Config for Cursor Visibility
    if [ -f "$KS_CONF" ]; then
        if ! grep -q "\[main\]" "$KS_CONF"; then
            echo -e "[main]\nshow_cursor = True" >> "$KS_CONF"
        elif ! grep -q "show_cursor" "$KS_CONF"; then
            sed -i '/\[main\]/a show_cursor = True' "$KS_CONF"
        else
            sed -i 's/show_cursor = .*/show_cursor = True/' "$KS_CONF"
        fi
    fi

    # 2. Inject the Modified Shutdown Panel (Quit to Console)
    if [ -d "$KS_PANEL_DIR" ] && [ -f "$PATCH_SRC" ]; then
        # Create a backup of the original KlipperScreen panel if not already backed up
        if [ ! -f "$KS_PANEL_DIR/shutdown.py.bak" ]; then
            cp "$KS_PANEL_DIR/shutdown.py" "$KS_PANEL_DIR/shutdown.py.bak"
        fi
        
        # Overwrite with the KlipKey version
        cp "$PATCH_SRC" "$KS_PANEL_DIR/shutdown.py"
        echo "UI Patch Applied: Shutdown panel updated."
    fi

    # 3. Reset the flag
    sed -i 's/^pending_ks_patch=true/pending_ks_patch=false/' ~/klipkey/klipkey.cfg
    echo "Patching complete. KlipperScreen will now start with cursor and console options."
fi
