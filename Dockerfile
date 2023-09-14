FROM registry.access.redhat.com/ubi8/ubi-minimal:8.3-298.1618432845

LABEL name="spaship/httpd" \
  summary="Apache Http Server for SPAship" \
  description="This a runtime image for SPAship apps" \
  maintainer="Arkaprovo Bhattacharjee <arbhatta@redhat.com>"

EXPOSE 8080

RUN microdnf install -y --nodocs httpd vim-minimal coreutils && microdnf clean all


RUN sed -i 's/Listen 80/Listen 8080/' /etc/httpd/conf/httpd.conf \
  && sed -i 's/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf \
  && chgrp -R 0 /var/log/httpd /var/run/httpd \
  && chmod -R g=u /var/log/httpd /var/run/httpd

ADD ./httpd.conf /etc/httpd/conf/
ADD ./conf.d/ /etc/httpd/conf.d/

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/httpd/access_log \
	&& ln -sf /dev/stderr /var/log/httpd/error_log

USER 1001

CMD httpd -D FOREGROUND
