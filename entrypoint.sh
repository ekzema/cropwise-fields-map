#!/bin/bash
set -e

rm -f /app/tmp/pids/server.pid

if bundle exec rails db:version | grep -qE 'Current version:($| 0$)'; then
  echo ">>> Database and tables not initialized, deleting db/structure.sql"
  rm -f db/structure.sql
fi

if [ -f db/structure.sql ]; then
  echo ">>> Start of cleaning the structure.sql"
  sed -i '/^SET statement_timeout =/d' db/structure.sql
  sed -i '/^SET transaction_timeout =/d' db/structure.sql
fi

exec "$@"
