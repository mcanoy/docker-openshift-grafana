FROM registry.access.redhat.com/rhel7
MAINTAINER Kevin McAnoy <kmcanoy@redhat.com>

ENV GRAFANA_VERSION="5.0.0-beta4"

LABEL name="Grafana" \
      io.k8s.display-name="Grafana" \
      io.k8s.description="Grafana Dashboard" \
      io.openshift.expose-services="3000" \
      io.openshift.tags="grafana" \
      build-date="2018-2-20" \
      version=$GRAFANA_VERSION \
      release="1"

# User grafana gets added by RPM
ENV USERNAME=grafana

RUN yum -y update && yum -y upgrade && \
    yum -y install https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-"$GRAFANA_VERSION".x86_64.rpm \
    && yum -y clean all && \
    rm -rf /var/cache/yum 

COPY ./root /
RUN /usr/bin/fix-permissions /var/log/grafana && \
    /usr/bin/fix-permissions /etc/grafana && \
    /usr/bin/fix-permissions /usr/share/grafana && \
    /usr/bin/fix-permissions /usr/sbin/grafana-server

VOLUME ["/var/lib/grafana", "/var/log/grafana", "/etc/grafana"]

EXPOSE 3000

ENTRYPOINT ["/usr/bin/rungrafana"]
