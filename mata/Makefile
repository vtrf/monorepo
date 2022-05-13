.POSIX:
.SUFFIXES:

GO = go
RM = rm
INSTALL = install
SCDOC = scdoc
GOLANGCILINT = golangci-lint
GOFLAGS =
PREFIX = /usr/local
BINDIR = bin
MANDIR = share/man

all: mata doc/mata.1

mata:
	$(GO) build -o mata cmd/mata/mata.go $(GOFLAGS)

doc/mata.1: doc/mata.1.scd
	$(SCDOC) <doc/mata.1.scd >doc/mata.1

clean:
	$(RM) -rf mata doc/mata.1

lint:
	$(GOLANGCILINT) run

test:
	$(GO) test ./... -v

install:
	$(INSTALL) -d \
		$(DESTDIR)$(PREFIX)/$(BINDIR)/ \
		$(DESTDIR)$(PREFIX)/$(MANDIR)/man1/

	$(INSTALL) -pm 0755 mata $(DESTDIR)$(PREFIX)/$(BINDIR)/
	$(INSTALL) -pm 0644 doc/*.1 $(DESTDIR)$(PREFIX)/$(MANDIR)/man1/

uninstall:
	$(RM) -f \
		$(DESTDIR)$(PREFIX)/$(BINDIR)/mata \
		$(DESTDIR)$(PREFIX)/$(MANDIR)/man1/* 

.PHONY: all mata clean install uninstall
