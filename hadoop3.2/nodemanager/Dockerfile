FROM coomia/hadoop3.2-base:0.2

MAINTAINER spancer.ray<spancer.roc.ray@gmail.com>

HEALTHCHECK CMD curl -f http://localhost:8042/ || exit 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8042

CMD ["/run.sh"]
