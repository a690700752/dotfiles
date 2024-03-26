#!/usr/bin/env python3

import subprocess
import sys


def switch_desktop(desktop_num):
    desktop_hash = {
        0: 29,
        1: 18,
        2: 19,
        3: 20,
        4: 21,
        5: 23,
        6: 22,
        7: 26,
        8: 28,
        9: 25,
    }
    desktop_key = desktop_hash.get(desktop_num)
    if desktop_key is not None:
        subprocess.run(
            [
                "osascript",
                "-e",
                f'tell application "System Events" to key code {desktop_key} using control down',
            ]
        )
    else:
        print(f"Invalid desktop number: {desktop_num}")


# 示例用法
switch_desktop(int(sys.argv[1]))
