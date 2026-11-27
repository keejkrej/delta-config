#!/bin/sh
set -eu

here=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
fallback=
if [ -n "${DELTA_CONFIG_DIR:-}" ]; then
    dest=$DELTA_CONFIG_DIR
else
    case "$(uname -s)" in
        Darwin)
            dest="$HOME/.config/delta"
            fallback="$HOME/Library/Application Support/delta"
            ;;
        Linux) dest="${XDG_CONFIG_HOME:-$HOME/.config}/delta" ;;
        *) printf '%s\n' 'Use install.ps1 on Windows.' >&2; exit 1 ;;
    esac
fi

target="$dest/AGENTS.md"
for folder in "$dest" "$fallback"; do
    [ -n "$folder" ] || continue
    for filename in AGENT.md AGENTS.md; do
        path="$folder/$filename"
        if [ -e "$path" ] || [ -L "$path" ]; then
            if [ "$path" = "$target" ] && cmp -s "$here/AGENTS.md" "$path"; then
                continue
            fi
            printf 'Existing rules at %s; merge the prompt manually to preserve them.\n' "$path" >&2
            exit 1
        fi
    done
done

if [ -f "$target" ]; then
    printf 'Already installed: %s\n' "$target"
else
    mkdir -p -- "$dest"
    (set -C; cat "$here/AGENTS.md" > "$target")
    printf 'Installed: %s\n' "$target"
fi
