#!/bin/sh
printf '\033c\033]0;%s\a' Hot Reload
base_path="$(dirname "$(realpath "$0")")"
"$base_path/hot-reload.x86_64" "$@"
