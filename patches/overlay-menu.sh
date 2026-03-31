#!/bin/bash
# KlipKey Floating Overlay Menu - V8 (Windowed Mode)
# Kill existing instances
pkill -f "yad --title=KLIPkey_Overlay"

# We remove --undecorated and add --close-on-unfocus (optional)
# We use --form with a single button to keep it thin
yad --image="dialog-question" \
    --title="KLIPkey Control" \
    --text="Close KlipperScreen?" \
    --button="Yes:0" \
    --button="No"

ret=$?

# If "Exit to Console" is clicked (Exit code 0)
if [[ $ret -eq 0 ]]; then
    sudo systemctl stop KlipperScreen
fi
