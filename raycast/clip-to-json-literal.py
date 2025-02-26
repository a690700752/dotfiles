#!/usr/bin/env python3

import subprocess
import json

def read_clipboard():
    """Read content from macOS clipboard using pbpaste"""
    return subprocess.run(['pbpaste'], capture_output=True, text=True).stdout.strip()

def write_clipboard(content):
    """Write content to macOS clipboard using pbcopy"""
    subprocess.run(['pbcopy'], input=content, text=True)

def convert_to_json_literal(text):
    """Convert text to JSON literal string"""
    return json.dumps(text)

def main():
    # Read clipboard content
    content = read_clipboard()
    
    # Convert to JSON literal
    json_literal = convert_to_json_literal(content)
    
    # Write back to clipboard
    write_clipboard(json_literal)
    
    print(f"Converted to JSON literal and copied to clipboard: {json_literal}")

if __name__ == '__main__':
    main()
