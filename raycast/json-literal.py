#!/usr/bin/env python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title JSON Literal
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📖
# @raycast.packageName Development

import subprocess
import json
import os

os.environ["LANG"] = "en_US.UTF-8"


def read_clipboard():
    """Read content from macOS clipboard using pbpaste"""
    result = subprocess.run(["pbpaste"], capture_output=True)
    return result.stdout.decode().strip()


def write_clipboard(content):
    """Write content to macOS clipboard using pbcopy"""
    subprocess.run(["pbcopy"], input=content, text=True)


def convert_to_json_literal(text):
    """Convert text to JSON literal string"""
    return json.dumps(text, ensure_ascii=False)


def main():
    # Read clipboard content
    content = read_clipboard()

    # Convert to JSON literal
    json_literal = convert_to_json_literal(content)

    # Write back to clipboard
    write_clipboard(json_literal)


if __name__ == "__main__":
    main()
