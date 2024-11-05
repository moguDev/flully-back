#!/bin/bash
set -e

rm -f /usr/src/app/tmp/pids/server.pid 

if [ "$RAILS_ENV" = "production" ]; then
  bundle exec rails db:create
  bundle exec rails db:migrate
fi

exec "$@"
