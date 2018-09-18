#!/usr/bin/env bash

default_build () {
  export APP_NAME=$1
  export VERSION=$2
  export CONTAINER_REGISTRY=$3

  if [ -z "$APP_NAME" ]; then
    log "Application name must be specified as first argument"
    exit 1
  fi

  if [ -z "$VERSION" ]; then
    log "Application version must be specified as second argument"
    exit 1
  fi

  GRADLE_TASKS="clean build"
  if [ "$(git rev-parse --abbrev-ref HEAD)" == "master" ]; then
     GRADLE_TASKS="clean build publish"
  fi

  log "Building $APP_NAME with version $VERSION. Tasks: $GRADLE_TASKS"

  if [ -n "$CONTAINER_REGISTRY" ]; then
      docker build --build-arg GRADLE_TASKS="${GRADLE_TASKS}" --build-arg VERSION="${VERSION}" --build-arg CONTAINER_REGISTRY="${CONTAINER_REGISTRY}" --no-cache --rm -t "${APP_NAME}:${VERSION}" -t "${APP_NAME}:latest" .
  else
      docker build --build-arg GRADLE_TASKS="${GRADLE_TASKS}" --build-arg VERSION="${VERSION}" --no-cache --rm -t "${APP_NAME}:${VERSION}" -t "${APP_NAME}:latest" .
  fi
}