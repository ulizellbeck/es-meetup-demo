FROM curlimages/curl:latest
WORKDIR seed

ARG ELASTICSEARCH_URL
ENV ELASTICSEARCH_URL=$ELASTICSEARCH_URL
ARG INDEX_NAME
ENV INDEX_NAME=$INDEX_NAME
ARG USER=admin
ENV USER=$USER
ARG PASSWORD=admin
ENV PASSWORD=$PASSWORD

COPY elasticsearch-seed-script.sh .

COPY index-templates/meetup.json /seed/index-templates/meetup.json

ENTRYPOINT ["sh", "elasticsearch-seed-script.sh"]