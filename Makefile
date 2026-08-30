# SPDX-License-Identifier: GPL-2.0
# Installs add.sh and no-item.sh as the `add` and `no-item` commands on
# PATH (as symlinks, so they always run the checked-out copy and keep
# writing to this directory's refs.txt), plus bash completion for them.

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
ADD_SCRIPT := $(CURDIR)/add.sh
ADD_TARGET := $(BINDIR)/add
NO_ITEM_SCRIPT := $(CURDIR)/no-item.sh
NO_ITEM_TARGET := $(BINDIR)/no-item
COMPLETIONSDIR ?= $(PREFIX)/share/bash-completion/completions
COMPLETION_SCRIPT := $(CURDIR)/completion.bash
COMPLETION_TARGET := $(COMPLETIONSDIR)/add
COMPLETION_NO_ITEM_TARGET := $(COMPLETIONSDIR)/no-item

.PHONY: install uninstall

install:
	install -d "$(BINDIR)"
	ln -sf "$(ADD_SCRIPT)" "$(ADD_TARGET)"
	ln -sf "$(NO_ITEM_SCRIPT)" "$(NO_ITEM_TARGET)"
	install -d "$(COMPLETIONSDIR)"
	ln -sf "$(COMPLETION_SCRIPT)" "$(COMPLETION_TARGET)"
	ln -sf "$(COMPLETION_SCRIPT)" "$(COMPLETION_NO_ITEM_TARGET)"

uninstall:
	rm -f "$(ADD_TARGET)" "$(NO_ITEM_TARGET)" "$(COMPLETION_TARGET)" "$(COMPLETION_NO_ITEM_TARGET)"
