#!/bin/bash

# Installs terraform-venv and opentofu-venv on Linux and macOS.
# (c) 2021-2026 NetTempo, Inc.
# MIT License, see LICENSE for details

usage () {
  echo "$0 [--user | --dir <directory>] [--uninstall]" 1>&2
  echo "where:" 1>&2
  echo "   {blank}:           install into /usr/local/bin (uses sudo if needed)" 1>&2
  echo "   --user:            install into ~/.local/bin" 1>&2
  echo "   --dir <directory>: install into <directory>" 1>&2
  echo "   --uninstall:       remove the commands instead of installing them" 1>&2
  exit 1
}

dest="/usr/local/bin"
uninstall=""
while [ $# -gt 0 ]; do
  case "$1" in
    --user)      dest="$HOME/.local/bin"; shift ;;
    --dir)       [ -n "$2" ] || usage; dest="$2"; shift 2 ;;
    --uninstall) uninstall="yes"; shift ;;
    -h|--help)   usage ;;
    *)           echo "Unknown option: $1" 1>&2; usage ;;
  esac
done

src_dir="$(cd "$(dirname "$0")" && pwd)"
if [ ! -f "$src_dir/terraform-venv" ]; then
  echo "Can't find terraform-venv next to $0" 1>&2
  exit 1
fi

# Use sudo only when the destination (or its nearest existing parent) isn't writable
check="$dest"
while [ ! -d "$check" ]; do check="$(dirname "$check")"; done
SUDO=""
if [ ! -w "$check" ]; then
  SUDO="sudo"
  echo "$dest is not writable, using sudo"
fi

if [ -n "$uninstall" ]; then
  $SUDO rm -f "$dest/terraform-venv" "$dest/opentofu-venv" || exit 1
  echo "Removed terraform-venv and opentofu-venv from $dest"
  exit 0
fi

$SUDO mkdir -p "$dest" || exit 1
$SUDO install -m 755 "$src_dir/terraform-venv" "$dest/terraform-venv" || exit 1
$SUDO ln -sf terraform-venv "$dest/opentofu-venv" || exit 1
echo "Installed terraform-venv and opentofu-venv into $dest"

case ":$PATH:" in
  *":$dest:"*) ;;
  *) echo "Note: $dest is not in your PATH. Add this to your shell profile:" 1>&2
     echo "  export PATH=\"$dest:\$PATH\"" 1>&2 ;;
esac
