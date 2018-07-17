#!/usr/bin/env bash

default_build () {
  check_dependency docker

  export APP_NAME=$1
  export VERSION=$2

  if [ -z $APP_NAME ]; then
    log "Application name must be specified as first argument"
    exit 1
  fi

  if [ -z $VERSION ]; then
    log "Application version must be specified as second argument"
    exit 1
  fi

  GRADLE_TASKS="clean build"
  if [ "$(git rev-parse --abbrev-ref HEAD)" == "master" ]; then
     GRADLE_TASKS="clean build publish"
  fi

  log "Building" $APP_NAME "with version" $VERSION". Tasks:" $GRADLE_TASKS

  publish_build_status 'INPROGRESS'

  docker build --build-arg GRADLE_TASKS="${GRADLE_TASKS}" --build-arg VERSION=${VERSION} --no-cache --rm -t ${APP_NAME}:${VERSION} -t ${APP_NAME}:latest .


  if [ $? -eq 0 ]; then
      publish_build_status 'SUCCESSFUL' && exit 0
  else
      publish_build_status 'FAILED' && exit 1
  fi

}