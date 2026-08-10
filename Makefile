# SPDX-License-Identifier: GPL-2.0
# Installs add.sh as the `add` command on PATH (as a symlink, so it always
# runs the checked-out copy and keeps writing to this directory's refs.txt).

PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin
SCRIPT := $(CURDIR)/add.sh
TARGET := $(BINDIR)/add

.PHONY: install uninstall

install:
	install -d "$(BINDIR)"
	ln -sf "$(SCRIPT)" "$(TARGET)"

uninstall:
	rm -f "$(TARGET)"
