#!/bin/sh

echo ELASTICSEARCH_URL: "$ELASTICSEARCH_URL"

until $(curl -XGET "$ELASTICSEARCH_URL/_cluster/health?wait_for_status=green" > /dev/null); do
    printf 'WAITING FOR THE ELASTICSEARCH ENDPOINT BE AVAILABLE, trying again in 5 seconds \n'
    sleep 5
done

# Load any declared extra index templates
INDEX_TEMPLATES=/seed/index-templates/*.json
for f in $INDEX_TEMPLATES
do
     filename=$(basename $f)
     template_id="${filename%.*}"
     echo "Loading $template_id template..."
     curl -s  -H 'Content-Type: application/json' -XPUT "$ELASTICSEARCH_URL/_template/$template_id" -d@$f
done