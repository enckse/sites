#!/bin/bash
STORE=/opt/whoami
CACHE=/var/cache/sitedeploy.contents
PREV=$CACHE.prev

while [ 1 -eq 1 ] ; do
    cd $STORE
    git pull > /dev/null 2>&1
    find . -type f -exec md5sum {} \; > $CACHE
    if [ -e $PREV ]; then
        diff -u $PREV $CACHE
        if [ $? -eq 0 ]; then
            sleep 10
            continue
        fi
    fi
    echo "regenerate sites"
    mv $CACHE $PREV
    rsync -avc $STORE/voidedtech.com/ /webserver/main --delete-after
    ln -s /opt/external/ /webserver/main/binaries
    cd $STORE/crossstitch.info
    perl build.pl
done
