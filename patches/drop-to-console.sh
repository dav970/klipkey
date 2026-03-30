#!/bin/bash
# KlipKey UI Rescue Trigger
# This stops KlipperScreen to reveal the underlying terminal console.

sudo systemctl stop KlipperScreen
clear
echo -e "\033[0;32mKlipperScreen stopped.\033[0m"
echo "You are now at the system console. Type 'launcher' to return to KLIPkey."
