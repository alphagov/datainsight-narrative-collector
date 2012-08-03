#!/usr/bin/env bash

set -e

ANSI_YELLOW="\033[33m"
ANSI_RESET="\033[0m"
PACKAGE_NAME="narrative"

echo -e "${ANSI_YELLOW}Installing dependencies${ANSI_RESET}"
bundle install --path vendor --local
bundle exec whenever --update-crontab datainsight-collector-$PACKAGE_NAME
