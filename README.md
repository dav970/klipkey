# KLIPkey 🛠️

KLIPkey is a lightweight management layer for Linux-based Klipper printer appliances. It provides an automated way to handle system maintenance, configuration patching, and console access without needing a keyboard or SSH.

## 🚀 Key Features

* **Floating Overlay Menu:** A touch-friendly GUI that allows users to exit KlipperScreen and drop to the console directly from the display.
* **Auto-Patching:** Automatically forces system configurations (like cursor visibility) before the main UI loads.
* **Launcher Integration:** Includes a dedicated launcher for quick access to system tools and help documentation.
* **Service-Based Architecture:** Uses systemd units to ensure high availability and proper execution timing.

## 📂 Repository Structure

* **`/patches`**: Contains the core logic for system overrides and the floating overlay UI.
* **`/service-monitor`**: Tools for monitoring and auto-restarting critical printer services.
* **`/factory-reset`**: Safety scripts to revert the appliance to a clean state.
* **`klipkey.cfg.template`**: The base configuration file. Copy this to `klipkey.cfg` to customize your installation.
* **`help.txt`**: The offline manual accessed via the launcher's `?` key.

## 🛠️ Installation

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/dav970/klipkey.git](https://github.com/dav970/klipkey.git)
   cd ~/klipkey
