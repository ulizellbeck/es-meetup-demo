FROM docker.elastic.co/elasticsearch/elasticsearch:8.4.3

# Add your elasticsearch plugins setup here
# Example: RUN elasticsearch-plugin install analysis-icu
COPY ./docker-entrypoint.sh . 
COPY ./index_template.json . 
USER root
#RUN mkdir /data && chown -R elasticsearch:elasticsearch /data && echo 'path.data: /data' >> config/elasticsearch.yml 
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/e1f115e4ca285c3c24e847c4dd4be955e0ed51c2/wait-for-it.sh /utils/wait-for-it.sh 
# Copy the files you may need and your insert script 
USER elasticsearch
RUN elasticsearch -p /tmp/epid & /bin/bash /utils/wait-for-it.sh -t 0 localhost:9200 -- curl -X PUT 'https://localhost:9200/_index_template/meetup' -d @./index_template.json; kill $(cat /tmp/epid) && wait $(cat /tmp/epid); exit 0;
#RUN echo (curl -s -w localhost:9200) 
#RUN ./docker-entrypoint.sh elasticsearch -p /tmp/epid & /bin/bash /utils/wait-for-it.sh -t 0 elasticsearch:9200 -- curl -X PUT 'https://elasticsearch:9200/_index_template/meetup' -d @./index_template.json; kill $(cat /tmp/epid) && wait $(cat /tmp/epid); exit 0;