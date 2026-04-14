#!/usr/bin/env bash

is_sourced=0

if [ -n "${ZSH_EVAL_CONTEXT:-}" ]; then
  case "$ZSH_EVAL_CONTEXT" in
    *:file)
      is_sourced=1
      ;;
  esac
fi

if [ -n "${BASH_VERSION:-}" ] && [ "${BASH_SOURCE[0]}" != "$0" ]; then
  is_sourced=1
fi

if [ "$is_sourced" -ne 1 ]; then
  echo "Run this script with: source ./reload-shell.sh"
  exit 1
fi

if [ -f "$HOME/.zshrc" ]; then
  # shellcheck disable=SC1090
  . "$HOME/.zshrc"
  echo "Reloaded ~/.zshrc"

  if command -v confpull &>/dev/null; then
    confpull
  else
    echo "confpull not available after sourcing ~/.zshrc"
  fi
else
  echo "~/.zshrc not found"
fi

if command -v tmux &>/dev/null; then
  if [ -f "$HOME/.tmux.conf" ]; then
    tmux source-file "$HOME/.tmux.conf"
    echo "Reloaded ~/.tmux.conf"
  else
    echo "~/.tmux.conf not found"
  fi
else
  echo "tmux not installed"
fi
