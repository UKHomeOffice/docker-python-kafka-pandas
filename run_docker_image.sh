#!/usr/bin/env sh

set +x

# Attach host network to allow DNS resolution via local DNS resolution service
docker run \
  --rm \
  -ti crt-s3-backup:dev1 \
  $@
