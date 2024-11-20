#!/usr/bin/env python3

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Put Clip
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📋

import sys
import subprocess
import requests

API_KEY = "lpVmz5x9ouw7Z5"
API_URL = "https://clip.998868.xyz/api/clip"


def read_clipboard():
    """Read clipboard content using pbpaste command."""
    try:
        result = subprocess.run(["pbpaste"], capture_output=True, text=True)
        return result.stdout
    except Exception as e:
        print(f"Error reading clipboard: {e}")
        return None


def send_to_api(content):
    """Send content to the clip API."""
    try:
        payload = {"key": API_KEY, "content": content}
        response = requests.post(API_URL, json=payload)
        response.raise_for_status()
        return response.json()
    except Exception as e:
        print(f"Error sending to API: {e}")
        return None


clipboard_content = read_clipboard()
if clipboard_content:
    result = send_to_api(clipboard_content)
    if result:
        print("Successfully sent to API")
    else:
        print("Failed to send to API")
else:
    print("Failed to read clipboard")
