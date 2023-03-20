#!/bin/bash

export D=${D}

rm $D/etc/opkg/oe-alliance-picon-feed.conf >/dev/null 2>&1 || true
echo src/gz oe-alliance-picon-feed https://raw.githubusercontent.com/oe-alliance/picons-feed/gh-pages > $D/etc/opkg/oe-alliance-picon-feed.conf
opkg update
echo " "
echo "oe-alliance-picon-feed succesfully installed"
echo " "
exit 0