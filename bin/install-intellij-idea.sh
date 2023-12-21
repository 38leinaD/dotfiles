#!/bin/bash
set -e

sudo echo

IDEA_DOWNLOAD_LINK=$(curl https://data.services.jetbrains.com/products\?code\=IIU\&release.type\=eap%2Crc%2Crelease\&fields\=distributions%2Clink%2Cname%2Creleases | jq -r '.[0].releases[0].downloads.linux.link')

IDEA_TAR=$(echo $IDEA_DOWNLOAD_LINK | rev | cut -d / -f1 | rev)

if [ ! -e ~/Downloads/$IDEA_TAR ]; then
	pushd ~/Downloads
	curl -LO $IDEA_DOWNLOAD_LINK
	popd
fi

TMP=$(mktemp -d)
echo "Using temporary directory $TMP"

tar -xzf ~/Downloads/$IDEA_TAR -C $TMP
IDEA_DIR=$(ls $TMP)
sudo mv $TMP/$IDEA_DIR /opt/
sudo rm -f /usr/local/bin/idea
sudo ln -s /opt/$IDEA_DIR/bin/idea.sh /usr/local/bin/idea
