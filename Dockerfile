FROM debian:buster-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
	gnupg2 \
	wget \
	ca-certificates

RUN wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
RUN echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list
ENV ES_HOME=/usr/share/elasticsearch
ENV ES_CONF=${ES_HOME}/config
RUN apt-get update && apt-get install -y --no-install-recommends \
	elasticsearch

RUN apt-get purge -y gnupg2 wget ca-certificates && apt-get autoremove -y

RUN mkdir -p ${ES_CONF}
COPY ./jvm.options ${ES_CONF}/jvm.options
COPY ./log4j2.properties ${ES_CONF}/log4j2.properties
COPY ./elasticsearch.yml ${ES_CONF}/elasticsearch.yml

COPY ./start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

RUN sed -i -e "s#ES_PATH_CONF=/etc/elasticsearch#ES_PATH_CONF=${ES_CONF}#g" /etc/default/elasticsearch

EXPOSE 9200

RUN touch ${ES_CONF}/users
RUN touch ${ES_CONF}/users_roles
RUN chown -R elasticsearch:elasticsearch ${ES_HOME}
USER elasticsearch

CMD /usr/local/bin/start.sh
