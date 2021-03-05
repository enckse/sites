#!/bin/bash
SRV=/srv/git
if [ ! -d $SRV ]; then
    mkdir -p $SRV
    ln -s /opt/git/public/ $SRV/cgit.voidedtech.com
fi
/usr/bin/git daemon --reuseaddr --export-all --interpolated-path=$SRV/%H/\%D
