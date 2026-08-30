#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0
# Append a no-item ("\n") to the target file.
#
# add.sh now prompts interactively for text when called with no arguments,
# so this script exists to add a no-item unconditionally, without prompting.
#
# The target file defaults to refs.txt next to this script, but can be
# overridden with the LIB_FILE environment variable (see add.sh).
#
# Usage: ./no-item.sh
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
REFS_FILE="${LIB_FILE:-$(dirname "$SCRIPT_PATH")/refs.txt}"

[[ $# -eq 0 ]] || { echo "Usage: $0" >&2; exit 1; }

printf '\n' >> "$REFS_FILE"
