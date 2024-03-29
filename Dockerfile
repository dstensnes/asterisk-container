FROM alpine:3.19

RUN addgroup -g 5060 asterisk && adduser -H -D -h /var/lib/asterisk -u 5060 -s /bin/nologin -g asterisk -G asterisk asterisk
RUN apk add \
    patch \
    asterisk \
    asterisk-alsa \
    asterisk-curl \
    asterisk-opus \
    asterisk-sample-config \
    asterisk-sounds-en \
    asterisk-sounds-moh \
    asterisk-speex \
    asterisk-srtp \
    asterisk-tds
RUN mkdir /usr/share/asterisk \
    && mv /etc/asterisk /usr/share/asterisk/default-config \
    && mkdir /etc/asterisk \
    && chgrp asterisk /etc/asterisk \
    && chmod 0750 /etc/asterisk

COPY entrypoint.sh /entrypoint.sh
COPY patches/*.patch /usr/share/asterisk/patches/

ENTRYPOINT /bin/sh /entrypoint.sh "$0" "$@"
CMD ["entrypoint"]
