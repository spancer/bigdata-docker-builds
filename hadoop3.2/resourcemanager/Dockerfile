FROM coomia/hadoop3.2-base:0.1

MAINTAINER spancer.ray<spancer.roc.ray@gmail.com>

HEALTHCHECK CMD curl -f http://localhost:8088/ || exit 1

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 8088

CMD ["/run.sh"]
