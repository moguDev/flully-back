#!/bin/bash
set -e

rm -f /usr/src/app/tmp/pids/server.pid 

bundle exec rails db:migrate

exec "$@"
