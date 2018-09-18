#!/usr/bin/env bash

default_build () {
  export APP_NAME=$1
  export VERSION=$2
  export CONTAINER_REGISTRY=$3

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

  BUILD_ARGS="--build-arg GRADLE_TASKS='${GRADLE_TASKS}' --build-arg VERSION=${VERSION}"
  if [ ! -z $CONTAINER_REGISTRY ]; then
    BUILD_ARGS+=" --build-arg CONTAINER_REGISTRY=${CONTAINER_REGISTRY}"
  fi

  log "Building $APP_NAME with version $VERSION. Tasks: $GRADLE_TASKS"

  docker build ${BUILD_ARGS} --no-cache --rm -t ${APP_NAME}:${VERSION} -t ${APP_NAME}:latest .
}