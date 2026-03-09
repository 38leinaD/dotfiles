#!/usr/bin/env bash

HISTORY="$HOME/.zsh_history"
BACKUP="$HOME/.zsh_history.backup"

usage() {
    echo "Usage: $(basename "$0") [-r|--recover]"
    echo "  (no flag)        Backup: move .zsh_history to .zsh_history.backup"
    echo "  -r, --recover    Recover: overwrite .zsh_history with .zsh_history.backup"
}

if [[ "$1" == "--recover" || "$1" == "-r" ]]; then
    if [[ ! -f "$BACKUP" ]]; then
        echo "Error: no backup found at $BACKUP" >&2
        exit 1
    fi
    mv -f "$BACKUP" "$HISTORY"
    echo "Recovered: $BACKUP -> $HISTORY"
elif [[ -z "$1" ]]; then
    if [[ ! -f "$HISTORY" ]]; then
        echo "Error: no history file found at $HISTORY" >&2
        exit 1
    fi
    mv "$HISTORY" "$BACKUP"
    echo "Backed up: $HISTORY -> $BACKUP"
else
    usage >&2
    exit 1
fi
