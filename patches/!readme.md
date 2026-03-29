# KLIPkey Patches

This folder contains the known‑good files used to restore KlipperScreen
functionality on the KLIPkey appliance. These files are copied directly into
their target locations by the `apply_ks_patch` script.

## Files

### `shutdown.py`
Replaces the KlipperScreen shutdown panel with the KLIPkey version that supports
Exit‑to‑Console behavior.

Target location:
/home/user/KlipperScreen/panels/shutdown.py

### `KlipperScreen.conf`
Provides the minimal supported configuration for the stable KlipperScreen
release.

Target location:
/home/user/printer_data/config/KlipperScreen.conf

## Usage
These files are applied by running:
~/klipkey/apply_ks_patch
This overwrites the existing files and restarts KlipperScreen.

