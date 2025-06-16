#!/usr/bin/env python3
import json
import subprocess
import re
from collections import defaultdict

CLASS_ICONS = {
    "firefox": "",
    "org.mozilla.firefox": "",
    "code": "",
    "Code": "",
    "Alacritty": "",
    "kitty": "",
    "Spotify": "",
    "TelegramDesktop": "",
    "Thunar": "",
    "nvim": "",
    "default": "",
}


def map_icon(class_name):
    return CLASS_ICONS.get(class_name, CLASS_ICONS["default"])


def get_tree():
    result = subprocess.run(
        ["i3-msg", "-t", "get_tree"], capture_output=True, text=True
    )
    return json.loads(result.stdout)


def get_workspaces():
    result = subprocess.run(
        ["i3-msg", "-t", "get_workspaces"], capture_output=True, text=True
    )
    return json.loads(result.stdout)


def collect_windows(node, current_ws=None):
    windows = defaultdict(list)

    if node.get("type") == "workspace":
        current_ws = node.get("name")

    if node.get("window_properties") and current_ws:
        class_name = node["window_properties"].get("class", "unknown")
        windows[current_ws].append(class_name)

    for child in node.get("nodes", []) + node.get("floating_nodes", []):
        child_windows = collect_windows(child, current_ws)
        for ws, classes in child_windows.items():
            windows[ws].extend(classes)

    return windows


def normalize_name(name):
    return re.match(r"^(\d+)", name).group(1) if re.match(r"^\d+", name) else name


def rename_workspaces():
    tree = get_tree()
    windows_by_ws = collect_windows(tree)
    active_workspaces = get_workspaces()

    for ws in active_workspaces:
        full_name = ws["name"]
        base_name = normalize_name(full_name)
        class_list = windows_by_ws.get(full_name, [])

        icons = " ".join(map_icon(cls) for cls in class_list)
        new_name = f"{base_name}: {icons}" if icons else base_name

        if new_name != full_name:
            subprocess.run(
                ["i3-msg", f'rename workspace "{full_name}" to "{new_name}"']
            )


if __name__ == "__main__":
    rename_workspaces()
