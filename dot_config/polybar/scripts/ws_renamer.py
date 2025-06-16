#!/usr/bin/env python3
import i3ipc
import re
from collections import defaultdict

# Mapping class -> icône
CLASS_ICONS = {
    "firefox": "",
    "org.mozilla.firefox": "",
    "code": "",
    "Code": "",
    "Alacritty": "",
    "kitty": "",
    "Spotify": "",
    "Thunar": "",
    "nvim": "",
    "Discord": "",
    "discord": "",
    "Cider": "",
    "cider": "",
    "default": "",
}


def map_icon(class_name):
    return CLASS_ICONS.get(class_name, CLASS_ICONS["default"])


def normalize_name(name):
    return re.match(r"^(\d+)", name).group(1) if re.match(r"^\d+", name) else name


def collect_windows(tree):
    windows = defaultdict(list)

    def walk(node, current_ws=None):
        if node.type == "workspace":
            current_ws = node.name

        if node.window_class and current_ws:
            windows[current_ws].append(node.window_class)

        for n in node.nodes + node.floating_nodes:
            walk(n, current_ws)

    walk(tree)
    return windows


def rename_workspaces(i3):
    tree = i3.get_tree()
    windows_by_ws = collect_windows(tree)
    workspaces = i3.get_workspaces()

    for ws in workspaces:
        full_name = ws.name
        base_name = normalize_name(full_name)
        class_list = windows_by_ws.get(full_name, [])

        icons = " ".join(map_icon(cls) for cls in class_list)
        new_name = f"{base_name}: {icons}" if icons else base_name

        if new_name != full_name:
            i3.command(f'rename workspace "{full_name}" to "{new_name}"')


def main():
    i3 = i3ipc.Connection()

    def on_event(*_):
        rename_workspaces(i3)

    i3.on("window::new", on_event)
    i3.on("window::close", on_event)
    i3.on("window::move", on_event)
    i3.on("workspace::focus", on_event)

    rename_workspaces(i3)
    i3.main()


if __name__ == "__main__":
    main()
