#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0
# Append an entry to refs.txt.
#
# refs.txt is a line-oriented text file where each line (<text>\n) is one
# of three kinds of entry:
#   item      "<text>\n"        — a regular entry
#   no-item   "\n"              — an empty line, a placeholder/spacer
#   ref       "ref: <text>\n"   — a reference that points at a subset of
#                                 the file's own item entries (a 1:m
#                                 relationship from this ref to those items)
#
# This script appends one such entry per invocation.
#
# Usage: ./add.sh [ref] [word ...] [-n]
#   ref    literal token "ref" — if present, the entry is prefixed "ref: "
#   word   the entry text, as one or more unquoted words joined with a
#          single space (may be omitted or empty for a blank line)
#   -n     suppress the additional trailing empty line
#
# Interactive mode: running with no arguments at all from a terminal (no
# redirected stdin) prompts for the entry text on the next line instead of
# immediately adding a no-item. The text is read raw via `read`, so it is
# not subject to shell word-splitting or quoting — an apostrophe like in
# "Maggie's Farm" needs no escaping or quotes there. An empty line at the
# prompt falls back to adding a no-item, same as `./add.sh` with redirected
# or no stdin.
#
# To add a no-item unconditionally without prompting, use no-item.sh instead.
#
# Examples:
#   ./add.sh                  # adds a no-item ("\n"), or prompts for text
#   ./add.sh ""               # same as above
#   ./add.sh test             # adds an item ("test\n") and a no-item ("\n")
#   ./add.sh test -n          # adds only the item ("test\n"), no no-item
#   ./add.sh ref test         # adds a ref ("ref: test\n") and a no-item ("\n")
#   ./add.sh ref test -n      # adds only the ref ("ref: test\n"), no no-item
#   ./add.sh ref               # adds an empty ref ("ref: \n") and a no-item ("\n")
#   ./add.sh ref -n            # adds only an empty ref ("ref: \n"), no no-item
#   ./add.sh -n                # adds nothing and prints the usage message
#   ./add.sh "" -n             # same as above (empty text is the same as no text)
#
# If <text> is longer than 79 characters (e.g. <longtext> below), it is
# wrapped: split into substrings, each shorter than 79 characters, breaking
# only on spaces (never mid-word). Each substring becomes its own item/ref,
# followed by the same trailing no-item (or lack thereof, with -n) as the
# single-line case:
#   ./add.sh <longtext>       # adds items <substr_0>\n...\n<substr_n>\n and a no-item
#   ./add.sh <longtext> -n    # adds only the items <substr_0>\n...\n<substr_n>\n
#   ./add.sh ref <longtext>       # adds refs "ref: <substr_0>\n"..."ref: <substr_n>\n" and a no-item
#   ./add.sh ref <longtext> -n    # adds only the refs "ref: <substr_0>\n"..."ref: <substr_n>\n"
set -euo pipefail

SCRIPT_PATH="$(readlink -f "${BASH_SOURCE[0]}")"
REFS_FILE="$(dirname "$SCRIPT_PATH")/refs.txt"
LINE_LIMIT=79
usage() { echo "Usage: $0 [ref] <str> [-n]" >&2; exit 1; }

# Wraps $1 into lines shorter than LINE_LIMIT characters, splitting only on
# spaces (never mid-word), and prints one line per substring.
wrap_text() {
    local text="$1" word line=""
    local -a words
    IFS=' ' read -r -a words <<< "$text"
    for word in "${words[@]}"; do
        if [[ -z "$line" ]]; then
            line="$word"
        elif (( ${#line} + 1 + ${#word} < LINE_LIMIT )); then
            line="$line $word"
        else
            printf '%s\n' "$line"
            line="$word"
        fi
    done
    [[ -n "$line" ]] && printf '%s\n' "$line"
}

suppress=""
args=("$@")
if [[ ${#args[@]} -gt 0 ]] && [[ "${args[-1]}" == "-n" ]]; then
    suppress="1"
    unset 'args[-1]'
fi

prefix=""
if [[ ${#args[@]} -gt 0 ]] && [[ "${args[0]}" == "ref" ]]; then
    prefix="ref: "
    unset 'args[0]'
    args=("${args[@]}")
fi

case ${#args[@]} in
    0)
        text=""
        if [[ -t 0 ]]; then
            read -r -p "> " text
        fi
        ;;
    *) text="${args[*]}" ;;
esac

content="${prefix}${text}"

if [[ -z "$content" ]]; then
    if [[ -n "$suppress" ]]; then
        usage
    fi
    printf '\n' >> "$REFS_FILE"
    exit 0
fi

if (( ${#text} > LINE_LIMIT )); then
    while IFS= read -r substr; do
        printf '%s\n' "${prefix}${substr}" >> "$REFS_FILE"
    done < <(wrap_text "$text")
else
    printf '%s\n' "$content" >> "$REFS_FILE"
fi
if [[ -z "$suppress" ]]; then
    printf '\n' >> "$REFS_FILE"
fi
