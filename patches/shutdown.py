# ============================================================
#  KlipperScreen Shutdown Panel — Patched Version
#
#  Added by: David Adams (david.adams@learnforever.org)
#
#  Changes:
#    • Added "Exit to Console" button to shutdown panel
#    • Button kills KlipperScreen and switches to TTY2
#    • Console prints restart instructions:
#         - How to restart KlipperScreen
#         - How to launch KIAUH
#    • KlipperScreen runs via startx/.xinitrc, not systemd
#      so pkill is used instead of systemctl
#
# ============================================================

import logging
import os

import gi

gi.require_version("Gtk", "3.0")
from gi.repository import Gtk
from ks_includes.screen_panel import ScreenPanel


class Panel(ScreenPanel):
    def __init__(self, screen, title):
        title = title or _("Shutdown")
        super().__init__(screen, title)

        estop = self._gtk.Button("emergency", _("Emergency Stop"), "color2")
        estop.connect("clicked", self.emergency_stop)

        power_panel = {
            "panel": "power",
        }
        power_shortcut = self._gtk.Button("shutdown", _("Power"), "color2")
        power_shortcut.connect("clicked", self.menu_item_clicked, power_panel)

        poweroff = self._gtk.Button("shutdown", _("Shutdown"), "color1")
        poweroff.connect("clicked", self.reboot_poweroff, "shutdown")

        restart = self._gtk.Button("refresh", _("Restart"), "color3")
        restart.connect("clicked", self.reboot_poweroff, "reboot")

        restart_ks = self._gtk.Button("refresh", _("Restart") + " KlipperScreen", "color3")
        restart_ks.connect("clicked", self._screen.restart_ks)

        lock_screen = self._gtk.Button("lock", _("Lock"), "color3")
        lock_screen.connect("clicked", self._screen.lock_screen.lock)

        self.main = Gtk.Grid(row_homogeneous=True, column_homogeneous=True)
        show_estop = self._printer and self._printer.state not in {'disconnected', 'startup', 'shutdown', 'error'}
        show_power_shortcut = False
        if self.ks_printer_cfg is not None and self._screen._ws.connected:
            power_devices = self.ks_printer_cfg.get("power_devices", "")
            if power_devices and self._printer.get_power_devices():
                show_power_shortcut = True

        if show_estop and show_power_shortcut:
            self.main.attach(estop, 0, 0, 1, 1)
            self.main.attach(power_shortcut, 0, 1, 1, 1)
        elif show_estop:
            self.main.attach(estop, 0, 0, 1, 2)
        elif show_power_shortcut:
            self.main.attach(power_shortcut, 0, 0, 1, 2)

        self.main.attach(restart_ks, 1, 0, 1, 1)
        self.main.attach(lock_screen, 2, 0, 1, 1)
        self.main.attach(poweroff, 1, 1, 1, 1)
        self.main.attach(restart, 2, 1, 1, 1)

        # --- Exit to Console button (added by David Adams) ---
        exit_btn = self._gtk.Button("console", _("Exit to Console"), "color3")
        exit_btn.connect("clicked", self.exit_to_console)
        self.main.attach(exit_btn, 0, 2, 3, 1)

        self.content.add(self.main)

    def reboot_poweroff(self, widget, method):
        label = Gtk.Label(wrap=True, hexpand=True, vexpand=True)
        if method == "reboot":
            label.set_label(_("Are you sure you wish to reboot the system?"))
            title = _("Restart")
        else:
            label.set_label(_("Are you sure you wish to shutdown the system?"))
            title = _("Shutdown")
        buttons = []
        if (
            self._screen.apiclient is None
            or "127.0.0.1" in self._screen.apiclient.endpoint
            or "localhost" in self._screen.apiclient.endpoint
        ):
            buttons.append({"name": _("Accept"), "response": Gtk.ResponseType.ACCEPT, "style": 'dialog-primary'})
        else:
            logging.info(self._screen.apiclient.endpoint)
            buttons.extend([
                {"name": _("Host"), "response": Gtk.ResponseType.OK, "style": 'dialog-info'},
                {"name": _("Printer"), "response": Gtk.ResponseType.APPLY, "style": 'dialog-warning'},
                {"name": _("Both"), "response": Gtk.ResponseType.ACCEPT, "style": 'dialog-primary'},
            ])
        buttons.append({"name": _("Cancel"), "response": Gtk.ResponseType.CANCEL, "style": 'dialog-error'})
        self._gtk.Dialog(title, buttons, label, self.reboot_poweroff_confirm, method)

    def reboot_poweroff_confirm(self, dialog, response_id, method):
        self._gtk.remove_dialog(dialog)
        if response_id == Gtk.ResponseType.ACCEPT:
            if method == "reboot":
                self._screen._ws.send_method("machine.reboot")
                os.system("systemctl reboot -i")
            else:
                self._screen._ws.send_method("machine.shutdown")
                os.system("systemctl poweroff -i")
        elif response_id == Gtk.ResponseType.OK:
            if method == "reboot":
                os.system("systemctl reboot -i")
            else:
                os.system("systemctl poweroff -i")
        elif response_id == Gtk.ResponseType.APPLY:
            if method == "reboot":
                self._screen._ws.send_method("machine.reboot")
            else:
                self.turn_off_power_devices()
                self._screen._ws.send_method("machine.shutdown")

    def turn_off_power_devices(self):
        if self.ks_printer_cfg is not None and self._screen._ws.connected:
            power_devices = self.ks_printer_cfg.get("power_devices", "")
            if power_devices and self._printer.get_power_devices():
                logging.info(f"Turning off associated power devices: {power_devices}")
                self._screen.power_devices(widget=None, devices=power_devices, on=False)
    # --- Exit to Console handler (added by David Adams) ---
    def exit_to_console(self, widget):
        logging.info("EXIT TO CONSOLE PRESSED")
        msg = (
            "\n\n"
            "============================================\n"
            "   KlipperScreen has been stopped.\n"
            "\n"
            "   To restart KlipperScreen:\n"
            "     sudo systemctl start KlipperScreen\n"
            "\n"
            "   To launch KIAUH:\n"
            "     ~/kiauh/kiauh.sh\n"
            "\n"
            "   To restart Klipper:\n"
            "     sudo systemctl restart klipper\n"
            "\n"
            "   To restart Moonraker:\n"
            "     sudo systemctl restart moonraker\n"
            "============================================\n\n"
        )
        try:
            with open("/dev/tty2", "w") as tty:
                tty.write(msg)
        except Exception as e:
            logging.error(f"TTY write failed: {e}")
        os.system("sudo chvt 2")
        os.system("sudo systemctl stop KlipperScreen")
