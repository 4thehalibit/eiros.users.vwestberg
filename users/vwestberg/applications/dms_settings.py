#!/usr/bin/env python3
import gi
gi.require_version('Gtk', '4.0')
gi.require_version('Adw', '1')
from gi.repository import Gtk, Adw
import json
import os
import subprocess
import sys

OVERRIDES = os.path.expanduser("~/eiros-config/dms-overrides.json")
SETTINGS  = os.path.expanduser("~/.config/DankMaterialShell/settings.json")


def load(path):
    try:
        with open(path) as f:
            return json.load(f)
    except Exception:
        return {}


def save(path, data):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w") as f:
        json.dump(data, f, indent=2)


class App(Adw.Application):
    def __init__(self):
        super().__init__(application_id="com.eiros.dms-settings")
        self.connect("activate", lambda a: Win(application=a).present())


class Win(Adw.ApplicationWindow):
    def __init__(self, **kw):
        super().__init__(**kw)
        self.set_title("DMS Settings")
        self.set_default_size(620, 800)

        self._live    = load(SETTINGS)
        self._pending = dict(load(OVERRIDES))

        overlay = Adw.ToastOverlay()
        self.set_content(overlay)
        self._toasts = overlay

        tv = Adw.ToolbarView()
        overlay.set_child(tv)

        hb = Adw.HeaderBar()
        tv.add_top_bar(hb)

        apply_btn = Gtk.Button(label="Apply")
        apply_btn.add_css_class("suggested-action")
        apply_btn.connect("clicked", self._apply)
        hb.pack_end(apply_btn)

        deploy_btn = Gtk.Button(label="Save & Deploy")
        deploy_btn.connect("clicked", self._save_deploy)
        hb.pack_end(deploy_btn)

        scroll = Gtk.ScrolledWindow(vexpand=True)
        scroll.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        tv.set_content(scroll)

        clamp = Adw.Clamp(maximum_size=720)
        clamp.set_margin_start(12)
        clamp.set_margin_end(12)
        scroll.set_child(clamp)

        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=24,
                      margin_top=24, margin_bottom=24)
        clamp.set_child(box)

        for section in [
            self._theme(),
            self._appearance(),
            self._bar(),
            self._clock_weather(),
            self._power(),
            self._notifications(),
        ]:
            box.append(section)

    # ── value helpers ─────────────────────────────────────────────────────

    def _val(self, key, default):
        return self._pending.get(key, self._live.get(key, default))

    def _set(self, key, value):
        self._pending[key] = value

    # ── widget builders ───────────────────────────────────────────────────

    def _group(self, title):
        return Adw.PreferencesGroup(title=title)

    def _switch(self, g, title, key, default=True):
        row = Adw.SwitchRow(title=title)
        row.set_active(bool(self._val(key, default)))
        row.connect("notify::active", lambda r, _: self._set(key, r.get_active()))
        g.add(row)

    def _combo(self, g, title, key, values, labels=None, default=None):
        if labels is None:
            labels = [str(v) for v in values]
        row = Adw.ComboRow(title=title)
        sl = Gtk.StringList()
        for lbl in labels:
            sl.append(lbl)
        row.set_model(sl)
        cur = self._val(key, default if default is not None else values[0])
        row.set_selected(values.index(cur) if cur in values else 0)
        row.connect("notify::selected",
                    lambda r, _: self._set(key, values[r.get_selected()]))
        g.add(row)

    def _spin(self, g, title, key, lo, hi, step, default, digits=0):
        row = Adw.SpinRow.new_with_range(lo, hi, step)
        row.set_title(title)
        row.set_digits(digits)
        row.set_value(float(self._val(key, default)))
        def changed(r, _):
            v = r.get_value()
            self._set(key, round(v, digits) if digits > 0 else int(v))
        row.connect("notify::value", changed)
        g.add(row)

    # ── sections ──────────────────────────────────────────────────────────

    def _theme(self):
        g = self._group("Theme")
        self._combo(g, "Color Scheme", "matugenScheme", [
            "scheme-tonal-spot", "scheme-content", "scheme-expressive",
            "scheme-fidelity", "scheme-monochrome", "scheme-neutral",
            "scheme-rainbow", "scheme-fruit-salad",
        ], default="scheme-rainbow")
        self._combo(g, "Base Theme", "currentThemeName", [
            "dynamic", "purple", "blue", "green", "red",
            "orange", "yellow", "pink", "grey",
        ], default="dynamic")
        self._spin(g, "Contrast", "matugenContrast", -1.0, 1.0, 0.1, 0, digits=1)
        return g

    def _appearance(self):
        g = self._group("Appearance")
        self._spin(g, "Popup Transparency", "popupTransparency", 0.0, 1.0, 0.05, 1.0, digits=2)
        self._combo(g, "Widget Color Mode", "widgetColorMode",
                    ["colorful", "primary", "surface"], default="colorful")
        self._spin(g, "Corner Radius (px)", "cornerRadius", 0, 32, 1, 12)
        self._combo(g, "Animation Speed", "animationSpeed",
                    [0, 1, 2, 3, 4],
                    ["None", "Slow", "Normal", "Fast", "Custom"],
                    default=1)
        self._switch(g, "Bar Elevation Shadow",  "barElevationEnabled",  False)
        self._switch(g, "M3 Elevation Shadows",  "m3ElevationEnabled",   True)
        self._switch(g, "Background Blur",        "blurEnabled",          False)
        self._switch(g, "Ripple Effects",         "enableRippleEffects",  True)
        return g

    def _bar(self):
        g = self._group("Bar Widgets")
        for key, label in [
            ("showLauncherButton",      "Launcher Button"),
            ("showWorkspaceSwitcher",   "Workspace Switcher"),
            ("showFocusedWindow",       "Focused Window"),
            ("showClock",               "Clock"),
            ("showWeather",             "Weather"),
            ("showMusic",               "Music / Media"),
            ("showClipboard",           "Clipboard"),
            ("showSystemTray",          "System Tray"),
            ("showCpuUsage",            "CPU Usage"),
            ("showMemUsage",            "Memory Usage"),
            ("showCpuTemp",             "CPU Temperature"),
            ("showGpuTemp",             "GPU Temperature"),
            ("showBattery",             "Battery"),
            ("showNotificationButton",  "Notification Button"),
            ("showControlCenterButton", "Control Center Button"),
            ("showCapsLockIndicator",   "Caps Lock Indicator"),
        ]:
            self._switch(g, label, key)
        return g

    def _clock_weather(self):
        g = self._group("Clock & Weather")
        self._switch(g, "24-Hour Clock",   "use24HourClock",   False)
        self._switch(g, "Show Seconds",    "showSeconds",       False)
        self._switch(g, "Weather Widget",  "weatherEnabled",    True)
        self._switch(g, "Use Fahrenheit",  "useFahrenheit",     False)
        self._switch(g, "Auto Location",   "useAutoLocation",   False)
        self._combo(g, "Wind Speed Unit", "windSpeedUnit",
                    ["kmh", "mph", "ms", "kn"], default="kmh")
        return g

    def _power(self):
        g = self._group("Power")
        self._spin(g, "Battery Charge Limit (%)", "batteryChargeLimit", 50, 100, 5, 100)
        return g

    def _notifications(self):
        g = self._group("Notifications")
        self._spin(g, "Timeout — Low (ms)",              "notificationTimeoutLow",      0, 30000, 500, 5000)
        self._spin(g, "Timeout — Normal (ms)",           "notificationTimeoutNormal",   0, 30000, 500, 5000)
        self._spin(g, "Timeout — Critical (ms, 0=never)","notificationTimeoutCritical", 0, 30000, 500, 0)
        self._switch(g, "Notification History", "notificationHistoryEnabled", True)
        return g

    # ── actions ───────────────────────────────────────────────────────────

    def _apply(self, _):
        s = load(SETTINGS)
        s.update(self._pending)
        save(SETTINGS, s)
        self._toasts.add_toast(Adw.Toast(title="Applied — visible in DMS immediately"))

    def _save_deploy(self, _):
        save(OVERRIDES, self._pending)
        self._toasts.add_toast(Adw.Toast(title="Saved — running deploy…"))
        subprocess.Popen(
            ["zsh", "-i", "-c", "deploy 'update dms settings'"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )


if __name__ == "__main__":
    App().run(sys.argv)
