# KLIPkey System Patches

This folder contains the scripts and system services required to modify the KlipperScreen environment and provide the KLIPkey overlay interface.

## Core Components

| File | Function | Trigger / Execution |
| :--- | :--- | :--- |
| **force-cursor.sh** | **Config Injector:** Uses `sed` to ensure `show_cursor = True` is set in the `KlipperScreen.conf`. | Triggered by `klipkey-preboot.service` **before** the UI loads. |
| **overlay-menu.sh** | **User Interface:** A `yad` based floating menu that allows the user to stop KlipperScreen and return to the console. | Triggered by `klipkey-overlay.service` **after** the system is idle. |
| **klipkey-preboot.service** | **Execution Guard:** A `oneshot` service that ensures configuration changes are written before the app reads them. | Runs automatically at boot **Before** `KlipperScreen.service`. |
| **klipkey-overlay.service** | **UI Manager:** Handles the environment variables and timing for the floating menu. | Runs automatically at boot **After** `KlipperScreen.service`. |

---

## Service Logic & Timing

The system uses a precise execution order to ensure the KLIPkey interface works without interfering with the printer's core functions:

1. **Phase 1 (Pre-Boot):** `klipkey-preboot.service` runs `force-cursor.sh`. This modifies the configuration file on the disk while KlipperScreen is still initialized.
2. **Phase 2 (KlipperScreen):** The main KlipperScreen service starts and reads the modified config (now showing the cursor).
3. **Phase 3 (Overlay):** `klipkey-overlay.service` waits for a 5-second stabilization period, then launches `overlay-menu.sh` on top of the existing X11 display.

## Maintenance

To manually restart the overlay menu after making changes to the UI script:
`sudo systemctl restart klipkey-overlay.service`

To verify that the pre-boot patch was successful:
`systemctl status klipkey-preboot.service`
