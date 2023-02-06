#!/bin/sh

echo ELASTICSEARCH_URL: "$ELASTICSEARCH_URL"
echo INDEX_NAME: "$INDEX_NAME"
echo USER: "$USER"
echo PASSWORD: "$PASSWORD"

until $(curl -XGET --insecure --user $USER:$PASSWORD "$ELASTICSEARCH_URL/_cluster/health?wait_for_status=green" > /dev/null); do
    printf 'WAITING FOR THE ELASTICSEARCH ENDPOINT BE AVAILABLE, trying again in 5 seconds \n'
    sleep 5
done

# Create the index
curl -XPUT --insecure --user $USER:$PASSWORD "$ELASTICSEARCH_URL/$INDEX_NAME" -H 'Content-Type: application/json' -d @index-settings.json

# The bulk operation to insert multiple documents into the index
curl -XPOST --insecure --user $USER:$PASSWORD "$ELASTICSEARCH_URL/$INDEX_NAME/_bulk" -H 'Content-Type: application/x-ndjson' --data-binary @index-bulk-payload.json

# Load any declared extra index templates
INDEX_TEMPLATES=/seed/index-templates/*.json
for f in $INDEX_TEMPLATES
do
     filename=$(basename $f)
     template_id="${filename%.*}"
     echo "Loading $template_id template..."
     curl -s  -H 'Content-Type: application/json' -XPUT --insecure --user $USER:$PASSWORD http://elasticsearch:9200/_template/$template_id -d@$f
     #We assume we want an index pattern in Kibana.
     #curl -s -XPUT http://elasticsearch:9200/.kibana/index-pattern/$template_id-* \
     #-d "{\"title\" : \"$template_id-*\",  \"timeFieldName\": \"@timestamp\"}"
done


SEARCH_TEMPLATES=/seed/search-templates/*.json
for f in $SEARCH_TEMPLATES
do
     filename=$(basename $f)
     template_id="${filename%.*}"
     echo "Loading $template_id template..."
     curl -s  -H 'Content-Type: application/json' -XPUT --insecure --user $USER:$PASSWORD http://elasticsearch:9200/_scripts/$template_id -d@$f
     #We assume we want an index pattern in Kibana.
     #curl -s -XPUT http://elasticsearch:9200/.kibana/index-pattern/$template_id-* \
     #-d "{\"title\" : \"$template_id-*\",  \"timeFieldName\": \"@timestamp\"}"
done


