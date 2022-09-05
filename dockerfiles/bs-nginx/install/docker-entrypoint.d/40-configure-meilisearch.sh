#!/bin/sh

# create configuration index name and search api key

ME=$(basename $0)
PATH_TO_ACCESS_FILE="/srv/xslt/access.json"



# modify access.json according to environment variables
configure_meilisearch_access_file () {
    echo >&3 "$ME: INFO: trying to create meilisearch access file"

    # check args
    test -z ${MEILI_HOST_URL} && echo >&3 "$ME: ERROR: MEILI_HOST_URL is undefined" && exit 1
    test -z ${MEILI_INDEX_NAME} && echo >&3 "$ME: ERROR: MEILI_INDEX_NAME is undefined" && exit 1
    test -z ${MEILI_SEARCH_KEY} && echo >&3 "$ME: ERROR: MEILI_SEARCH_KEY is undefined" && exit 1
    test -z ${PATH_TO_ACCESS_FILE} && echo >&3 "$ME: ERROR: PATH_TO_ACCESS_FILE is undefined" && exit 1

    local rendered=$(envsubst < $PATH_TO_ACCESS_FILE)
    printf "$rendered" > $PATH_TO_ACCESS_FILE

    # debug messages
    echo >&3 "$ME: DEBUG: meilisearch access file content"
    echo >&3 "$(cat $PATH_TO_ACCESS_FILE)"
    echo >&3 "$ME: INFO: successfully created meilisearch access file at $PATH_TO_ACCESS_FILE"
}


configure_meilisearch_index () {
    echo >&3 "$ME: INFO: trying to configure meilisearch index"

    # check args
    test -z ${MEILI_HOST_URL} && echo >&3 "$ME: ERROR: MEILI_HOST_URL is undefined" && exit 1
    test -z ${MEILI_INDEX_NAME} && echo >&3 "$ME: ERROR: MEILI_INDEX_NAME is undefined" && exit 1
    test -z ${MEILI_MASTER_KEY} && echo >&3 "$ME: ERROR: MEILI_MASTER_KEY is undefined" && exit 1

    echo >&3 "$ME: DEBUG: trying to create meilisearch index"
    curl -X POST "$MEILI_HOST_URL/indexes" \
        -H "Authorization: Bearer $MEILI_MASTER_KEY" \
        -H "Content-Type: application/json" \
        --data-binary "{\"uid\": \"$MEILI_INDEX_NAME\",\"primaryKey\": \"id\"}" \
        --silent | jq
    local exit_code=$?
    test "$exit_code" != "0" && echo >&3 "$ME: ERROR: failed to create meilisearch index_name=$MEILI_INDEX_NAME exit_code=$exit_code" \
                && exit 1
    echo >&3 "$ME: INFO: successfully created meilisearch index_name=$MEILI_INDEX_NAME exit_code=$exit_code"
}


configure_meilisearch_search_key () {
    echo >&3 "$ME: INFO: trying to configure meilisearch api search key"

    # check args
    test -z ${MEILI_HOST_URL} && echo >&3 "$ME: ERROR: MEILI_HOST_URL is undefined" && exit 1
    test -z ${MEILI_INDEX_NAME} && echo >&3 "$ME: ERROR: MEILI_INDEX_NAME is undefined" && exit 1
    test -z ${MEILI_MASTER_KEY} && echo >&3 "$ME: ERROR: MEILI_MASTER_KEY is undefined" && exit 1

    # trying to create search api key
    echo >&3 "$ME: DEBUG: trying to create meilisearch api search key"
    curl --silent -X POST "$MEILI_HOST_URL/keys" \
        -H "Authorization: Bearer $MEILI_MASTER_KEY" \
        -H "Content-Type: application/json" \
        --data-binary "{\"name\": \"$MEILI_INDEX_NAME\", \"uid\": \"$(uuidgen --namespace @oid --name "$MEILI_INDEX_NAME" --md5)\", \"actions\": [\"search\"],\"indexes\": [\"$MEILI_INDEX_NAME\"],\"expiresAt\": null}" | jq

    local exit_code=$?
    test "$exit_code" != "0" && echo >&3 "$ME: ERROR: failed to create meilisearch search_key exit_code=$exit_code" \
                && exit 1
    echo >&3 "$ME: DEBUG: successfully created meilisearch search key uid=$(uuidgen --namespace @oid --name "$MEILI_INDEX_NAME" --md5) exit_code=$exit_code"

    # get search api key
    echo >&3 "$ME: DEBUG: trying to get meilisearch search key uid=$(uuidgen --namespace @oid --name "$MEILI_INDEX_NAME" --md5)"
    http_response=$(curl --silent -X GET "$MEILI_HOST_URL/keys/$(uuidgen --namespace @oid --name "$MEILI_INDEX_NAME" --md5)" \
        -H "Authorization: Bearer $MEILI_MASTER_KEY" \
        -H "Content-Type: application/json" | jq)
    printf "$http_response\n"

    local exit_code=$?
    test "$exit_code" != "0" && echo >&3 "$ME: ERROR: failed to get meilisearch search_key uid=$(uuidgen --namespace @oid --name "$MEILI_INDEX_NAME" --md5) exit_code=$exit_code" \
                && exit 1

    export MEILI_SEARCH_KEY=$(echo $http_response | jq -r '.key')
    echo >&3 "$ME: INFO: successfully got meilisearch search_key=$MEILI_SEARCH_KEY exit_code=$exit_code"        
}


configure_meilisearch_index
configure_meilisearch_search_key
configure_meilisearch_access_file
exit 0