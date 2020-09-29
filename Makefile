prefix ?= /usr/local
bindir = $(prefix)/bin

build:
	swift build -c release --disable-sandbox

install: build
	install -d "$(bindir)"
	install ".build/release/xcodebuild-to-json" "$(bindir)"

uninstall:
	rm -rf "$(bindir)/xcodebuild-to-json"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
