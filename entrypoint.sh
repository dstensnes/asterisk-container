#! /bin/sh

function log () {
    echo "==ENTRYPOINT> $*"
}

function seed_config () {
    log 'Seeding default configuration'
    cp /usr/share/asterisk/default-config/* /etc/asterisk/
    chgrp asterisk /etc/asterisk/*
    chmod 0640 /etc/asterisk/*
    for i in /usr/share/asterisk/patches/*.patch ; do
        log "Applying patch \"$i\""
        [ -f "$i" ] && patch -d /etc/asterisk -p1 < "$i"
    done
}

[ "$1" = "-c" ] && shift
ARG="$1"

case "${ARG:-entrypoint}" in
    entrypoint)
        [ -z "$(ls -1 /etc/asterisk/*.conf 2> /dev/null)" ] && seed_config
        log "Starting asterisk"
        exec /usr/sbin/asterisk -f -i -n -p
        ;;
    seed)
        seed_config
        ;;
    shell)
        exec /usr/sbin/asterisk -r
        ;;
    /bin/sh|/bin/bash)
        shift
        exec /bin/sh "$@"
        ;;
    *)
        log "Unknown command: \"$*\""
        ;;
esac
