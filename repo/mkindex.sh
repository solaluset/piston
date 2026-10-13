#!/bin/sh

BASEURL=http://repo:8000/

add_pkg() {
    PKGFILE=$(basename "$1")
    PKGFILENAME=$(echo "$PKGFILE" | sed 's/\.pkg\.tar\.gz//g')

    PKGNAME=$(echo "$PKGFILENAME" | grep -oP '^\K.+(?=-)')
    PKGVERSION=$(echo "$PKGFILENAME" | grep -oP '^.+-\K.+')
    PKGCHECKSUM=$(sha256sum "$PKGFILE" | awk '{print $1}')

    echo "$PKGNAME,$PKGVERSION,$PKGCHECKSUM,$BASEURL$PKGFILE"
    echo "Adding package $PKGNAME-$PKGVERSION" >&2
}

find ../packages -type f -name "*.pkg.tar.gz" -exec cp '{}' . ';'
find . -type f -name "*.pkg.tar.gz" | (
    while read -r pkg; do
        add_pkg "$pkg"
    done
) > index
