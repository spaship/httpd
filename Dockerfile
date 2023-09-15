FROM registry.access.redhat.com/ubi9:9.2-755

LABEL name="spaship/httpd" \
  summary="Apache Http Server for SPAship" \
  description="This a runtime image for SPAship apps" \
  maintainer="Arkaprovo Bhattacharjee <arbhatta@redhat.com>"

EXPOSE 8080

RUN dnf install -y --nodocs --allowerasing coreutils httpd vim-minimal && \
    dnf clean all && \
    sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf && \
    sed -i 's/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf && \
    chgrp -R 0 /var/log/httpd /var/run/httpd && \
    chmod -R g=u /var/log/httpd /var/run/httpd && \
    ln -sf /dev/stdout /var/log/httpd/access_log && \
    ln -sf /dev/stderr /var/log/httpd/error_log

ADD ./httpd.conf /etc/httpd/conf/
ADD ./conf.d/ /etc/httpd/conf.d/

USER 1001

CMD httpd -D FOREGROUND
