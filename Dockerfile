FROM balenalib/raspberry-pi2-alpine

MAINTAINER Jakub 'q84fh' Skory <q84fh@q84fh.net>

RUN install_packages murmur

COPY docker-entrypoint.sh /

VOLUME /var/lib/murmur
VOLUME /var/lib/murmur/certs

EXPOSE 64738

CMD ["/docker-entrypoint.sh"]
