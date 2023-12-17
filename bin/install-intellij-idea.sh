#!/bin/bash
set -e
pushd ~/Downloads
curl -LO https://download.jetbrains.com/idea/ideaIU-2023.3.1.tar.gz
sudo tar -xzf ideaIU-*.tar.gz -C /opt
sudo ln -s /opt/idea-IU-233.11799.300/bin/idea.sh /usr/local/bin/idea



popd
