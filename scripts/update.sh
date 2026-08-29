#!/usr/bin/env bash

source "$(dirname "$0")/common.sh"

docker_compose pull

docker_compose up -d