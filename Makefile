VERSION=5.4.0
ARCHIVE=collectd-$(VERSION).tar.bz2
SHA1SUM=c2bc3ca3c62cfba4499c4eb14066a4c78301cc2c
SHA256SUM=90973894a1f10775d409fe23ce7bc4d89c1b7c6f4d9918b305d160605871923e

all: apt-builder-fetch apt-builder-build

apt-builder-fetch: fetch-src
	cp -al debian src

fetch-src:
	wget -nc http://apt.shopify.com/dist/collectd/$(ARCHIVE)
	@echo "$(SHA1SUM)  $(ARCHIVE)" | sha1sum --check
	@echo "$(SHA256SUM)  $(ARCHIVE)" | sha256sum --check
	rm -rf src && mkdir src
	tar --strip-components=1 -C src -jxf $(ARCHIVE)

apt-builder-deps:
	# noop

apt-builder-build:
	cd src && debuild -e MAKEFLAGS=-j16 -i -us -uc -b
	mv *.deb *.changes ..
