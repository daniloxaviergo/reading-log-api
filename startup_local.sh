#!/bin/bash

# Migration
bundle exec rake db:migrate

rm /app/tmp/pids/server.pid
bundle exec rails s -p 7107 -b '0.0.0.0'
