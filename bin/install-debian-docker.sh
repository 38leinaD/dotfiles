#!/bin/bash

  sudo apt-get update\nsudo apt-get install ca-certificates curl gnupg\nsudo install -m 0755 -d /etc/apt/keyrings\ncurl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg\nsudo chmod a+r /etc/apt/keyrings/docker.gpg
  echo \\n  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \\n  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \\n  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null\nsudo apt-get update
  sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  #sudo service docker start
  sudo groupadd docker
  sudo usermod -aG docker $USER
