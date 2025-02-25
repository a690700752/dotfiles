#!/usr/bin/env python3

import json
import subprocess

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title JSON Sort
# @raycast.mode silent

# Optional parameters:
# @raycast.icon 📋
# @raycast.packageName Development

def sort_dict(d):
    """Recursively sort dictionary by keys"""
    if isinstance(d, dict):
        return {k: sort_dict(v) for k, v in sorted(d.items())}
    elif isinstance(d, list):
        return [sort_dict(v) for v in d]
    return d

def main():
    try:
        # Get clipboard content
        clipboard = subprocess.run(['pbpaste'], capture_output=True, text=True).stdout
        
        # Parse and sort JSON
        data = json.loads(clipboard)
        sorted_data = sort_dict(data)
        
        # Convert to pretty JSON
        sorted_json = json.dumps(sorted_data, indent=2, ensure_ascii=False)
        
        # Set clipboard
        subprocess.run(['pbcopy'], input=sorted_json, text=True)
        print("JSON sorted and copied to clipboard!")
    except json.JSONDecodeError:
        print("Error: Clipboard content is not valid JSON")
    except Exception as e:
        print(f"Error: {str(e)}")

if __name__ == "__main__":
    main()
