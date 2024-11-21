#!/usr/bin/env python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Get Clip
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📋

import sys
import subprocess
import requests
import os

API_KEY = "lpVmz5x9ouw7Z5"
API_URL = "https://clip.998868.xyz/api/clip"


def write_clipboard(content):
    """Write content to clipboard using pbcopy command."""
    try:
        process = subprocess.Popen(
            ["pbcopy"],
            stdin=subprocess.PIPE,
            env={
                **os.environ,
                "LANG": "en_US.UTF-8",
            },
        )
        process.communicate(content.encode("utf-8"))
        return True
    except Exception as e:
        print(f"Error writing to clipboard: {e}")
        return False


def get_from_api():
    """Get content from the API."""
    try:
        response = requests.get(f"{API_URL}?key={API_KEY}")
        response.raise_for_status()
        data = response.json()

        if data.get("success"):
            return data.get("content", "")
        else:
            print(f"API Error: {data.get('error', 'Unknown error')}")
            return None

    except Exception as e:
        print(f"Error fetching from API: {e}")
        return None


def main():
    content = get_from_api()
    if content is not None:
        if write_clipboard(content):
            print("Clipboard updated successfully", content)
        else:
            print("Failed to update clipboard")
    else:
        print("Failed to get content from API")


if __name__ == "__main__":
    main()
