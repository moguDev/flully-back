#!/bin/bash
set -e

rm -f /usr/src/app/tmp/pids/server.pid 

exec "$@"
