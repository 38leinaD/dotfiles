#!/bin/bash

JMETER_ZIP=apache-jmeter-5.6.2.tgz
DOWNLOAD_DIR=~/Downloads

pushd $DOWNLOAD_DIR
curl -LO https://dlcdn.apache.org//jmeter/binaries/$JMETER_ZIP
pushd ~/tools/
tar -xf $DOWNLOAD_DIR/$JMETER_ZIP
ln -s ~/tools/${JMETER_ZIP%.*}/bin/jmeter.sh ~/bin/jmeter.sh
popd

popd

