#!/bin/bash

IMAGE_IDS=$(docker images | grep "^<none>" | awk "{print $3}")

if [ -n "$IMAGE_IDS" ]; then
  docker rmi $IMAGE_IDS > /dev/null 2>&1
fi
