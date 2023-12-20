#!/usr/bin/env bash

set -e

function prompt_yes_no() {
    local prompt="$1"
    local default="$2"
    local answer

    while true; do
        read -p "$prompt [y/n] " answer
        case "$answer" in
            [Yy]*) return 0 ;;
            [Nn]*) return 1 ;;
            "")    return "$default" ;;
            *)     echo "Please answer yes or no." ;;
        esac
    done
}

function link() {
    echo "Linking $2"
    if [ -e "$2" ]; then
        if prompt_yes_no "File $2 already exists. Overwrite?"; then
            rm -rf "$2"
        else
            return 0
        fi
    fi
    ln -s "$1" "$2"
}

function download_file() {
  file=$1
  url=$2
  if [ ! -e "${file}" ]; then
    curl -o "${file}" "${url}"
  fi
}

sh_path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# link $sh_path/../tmux.conf ~/.tmux.conf
# link $sh_path/../bashrc ~/.my_bashrc
# link $sh_path/../ideavimrc ~/.ideavimrc
# cp -ri $sh_path/../karabiner ~/.config/ || true
#
# echo "Copying gitconfig"
# cp -i $sh_path/../gitconfig ~/.gitconfig || true
#
# link $sh_path/../kitty ~/.config/kitty
link $sh_path/../nvim-vsc ~/.config/nvim-vsc

