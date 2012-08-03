#!/usr/bin/env bash

set -e

ANSI_YELLOW="\033[33m"
ANSI_RED="\033[31m"
ANSI_RESET="\033[0m"

export VERSION="$1"
if [ -z "$VERSION" ]; then
  echo "USAGE: release.sh <version-hash>"
  exit 1
fi

#HOST="deploy@datainsight"
HOST="deploy@datainsight.alphagov.co.uk"

scp datainsight-collector-narrative-$VERSION.zip $HOST:/srv/datainsight-collector-narrative/packages
# deploy
echo -e "${ANSI_YELLOW}Deploying package${ANSI_RESET}"
ssh $HOST "mkdir /srv/datainsight-collector-narrative/release/$VERSION; unzip -o /srv/datainsight-collector-narrative/packages/datainsight-collector-narrative-$VERSION.zip -d /srv/datainsight-collector-narrative/release/$VERSION;"
# link
echo -e "${ANSI_YELLOW}Linking package${ANSI_RESET}"
ssh $HOST "rm /srv/datainsight-collector-narrative/current; ln -s /srv/datainsight-collector-narrative/release/$VERSION/ /srv/datainsight-collector-narrative/current;"
# restart
echo -e "${ANSI_YELLOW}Updating crontab${ANSI_RESET}"
ssh $HOST "cd /srv/datainsight-collector-narrative/current; ./start.sh"
