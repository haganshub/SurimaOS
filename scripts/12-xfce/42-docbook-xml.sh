#!/bin/bash
#
# BLFS build: docbook-xml-4.5
# Run INSIDE the deployed SurimaOS system (not chroot). Usage: ./42-docbook-xml.sh [--force]
#
# Needed by itstool, needed by lightdm. Simple data-file install, no
# compilation, just DTD files and xmlcatalog entries.

source "$(cd "$(dirname "$0")" && pwd)/common.sh"
skip_if_done "12-docbook-xml" "$1"

echo "=== Installing docbook-xml-4.5 ==="

cd /root/src
rm -rf docbook-xml-4.5
mkdir docbook-xml-4.5
cd docbook-xml-4.5

wget https://www.docbook.org/xml/4.5/docbook-xml-4.5.zip
unzip -q docbook-xml-4.5.zip

install -v -d -m755 /usr/share/xml/docbook/xml-dtd-4.5
install -v -d -m755 /etc/xml
chown -R root:root .
cp -v -af docbook.cat *.dtd ent/ *.mod /usr/share/xml/docbook/xml-dtd-4.5

if [ ! -e /etc/xml/catalog ]; then
  xmlcatalog --noout --create /etc/xml/catalog
fi

xmlcatalog --noout --add "delegatePublic" \
    "-//OASIS//ENTITIES DocBook XML" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog
xmlcatalog --noout --add "delegatePublic" \
    "-//OASIS//DTD DocBook XML" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog
xmlcatalog --noout --add "delegateSystem" \
    "http://www.oasis-open.org/docbook/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog
xmlcatalog --noout --add "delegateURI" \
    "http://www.oasis-open.org/docbook/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog

if [ ! -e /etc/xml/docbook ]; then
  xmlcatalog --noout --create /etc/xml/docbook
fi

xmlcatalog --noout --add "public" \
    "-//OASIS//DTD DocBook XML V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/docbookx.dtd" \
    /etc/xml/docbook
xmlcatalog --noout --add "rewriteSystem" \
    "http://www.oasis-open.org/docbook/xml/4.5" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook
xmlcatalog --noout --add "rewriteURI" \
    "http://www.oasis-open.org/docbook/xml/4.5" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook

mark_done "12-docbook-xml"
echo "=== docbook-xml complete ==="
