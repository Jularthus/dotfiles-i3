#!/usr/bin/python

import json
import subprocess
from collections import defaultdict

# Mappage classe -> icône (Nerd Fonts / FontAwesome)
CLASS_ICONS = {
    "firefox": "",
    "org.mozilla.firefox": "",
    "code": "",
    "Code": "",
    "Alacritty": "",
    "kitty": "",
    "Thunar": "",
    "default": "",
}


def map_icon(class_name):
    return CLASS_ICONS.get(class_name, CLASS_ICONS["default"])


def get_i3_tree():
    result = subprocess.run(
        ["i3-msg", "-t", "get_tree"], capture_output=True, text=True
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


def main():
    tree = get_i3_tree()
    windows_by_ws = collect_windows(tree)

    output = []
    for ws, classes in sorted(windows_by_ws.items()):
        unique_icons = {map_icon(cls) for cls in classes}
        if unique_icons:
            output.append(f"{ws} {' '.join(sorted(unique_icons))}")

    print(" ".join(output))


if __name__ == "__main__":
    main()
