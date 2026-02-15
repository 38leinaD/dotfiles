#!/usr/bin/env bash
exec setsid google-chrome \
  --user-data-dir="$(mktemp -d)" \
  --no-first-run \
  --disable-sync \
  "$@" \
  > /dev/null 2>&1 < /dev/null &
