# SPDX-License-Identifier: GPL-2.0
# Bash completion for the `add` and `no-item` commands (see add.sh, no-item.sh).
#
# Source this file, or install it where your system loads bash completions
# (e.g. /etc/bash_completion.d/, or a directory listed in
# $BASH_COMPLETION_USER_DIR) to get completion for the `add` command
# installed by `make install`.

_add_completion() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD - 1]}"

    if [[ "$cur" == -* ]]; then
        COMPREPLY=($(compgen -W "-n" -- "$cur"))
        return
    fi

    if [[ $COMP_CWORD -eq 1 ]]; then
        COMPREPLY=($(compgen -W "ref help" -- "$cur"))
    fi
}

_no_item_completion() {
    COMPREPLY=()
}

complete -F _add_completion add
complete -F _no_item_completion no-item
complete -F _no_item_completion add-no-item

