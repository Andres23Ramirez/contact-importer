#!/bin/bash
rm -rf ./tmp/pids/*
bundle install
RACK_TIMEOUT_SERVICE_TIMEOUT=50 rails server -b 0.0.0.0