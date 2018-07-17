#!/usr/bin/env bash

publish_build_status() {

  if ! [ -z $BUILD_NUMBER ]; then

    local STATUS=$1

    log "Publishing ${STATUS} to bitbucket"

    if [ -z $ACCESS_TOKEN ]; then
      log "Getting access token from bitbucket"
      TOKEN_RESPONSE="$(curl  -s \
                            -u ${BITBUCKET_OAUTH_KEY}:${BITBUCKET_OAUTH_SECRET} \
                            -H 'Content-Type: application/x-www-form-urlencoded' \
                            -d 'grant_type=client_credentials' \
                            -X POST https://bitbucket.org/site/oauth2/access_token)"
      ACCESS_TOKEN=$(echo $TOKEN_RESPONSE | jq -r .access_token)
    fi

    GIT_COMMIT=$(git rev-parse HEAD)

    curl -s \
        -H 'Content-Type: application/json' \
        -H "Authorization: Bearer ${ACCESS_TOKEN}" \
        -X POST \
        -d "{\"state\":\"${STATUS}\",\"key\":\"${BUILD_NUMBER}\", \"url\":\"${BUILD_URL}\"}" \
        https://api.bitbucket.org/2.0/repositories/${OWNER}/${REPO}/commit/${GIT_COMMIT}/statuses/build \
        > /dev/null

  fi

}
