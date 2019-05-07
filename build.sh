#!/bin/bash -xe
DOCKER_BUILD_TAG="$(date +"%Y-%m-%d-%H-%M-%S")"
docker build -t "dhoodlum/jnlp_arch:${DOCKER_BUILD_TAG}" .
docker tag "dhoodlum/jnlp_arch:${DOCKER_BUILD_TAG}" dhoodlum/jnlp_arch:latest
