FROM registry.access.redhat.com/ubi8/python-39:latest

USER root

# Install Apache httpd development headers required to build mod_wsgi from source.
RUN dnf install -y httpd-devel && dnf clean all

COPY . /tmp/src

RUN mv /tmp/src/.s2i/bin /tmp/scripts

RUN rm -rf /tmp/src/.git* && \
    chown -R 1001 /tmp/src && \
    chgrp -R 0 /tmp/src && \
    chmod -R g+w /tmp/src

USER 1001

ENV S2I_SCRIPTS_PATH=/usr/libexec/s2i \
    S2I_BASH_ENV=/opt/app-root/etc/scl_enable \
    DISABLE_COLLECTSTATIC=1 \
    DISABLE_MIGRATE=1

RUN /tmp/scripts/assemble

CMD [ "/tmp/scripts/run" ]
