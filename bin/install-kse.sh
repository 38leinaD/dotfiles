#!/bin/bash

ZIP=kse-553.zip
DOWNLOAD_DIR=~/Downloads

pushd $DOWNLOAD_DIR
curl -LO https://github.com/kaikramer/keystore-explorer/releases/download/v5.5.3/$ZIP
pushd ~/tools/
unzip $DOWNLOAD_DIR/$ZIP
ln -s ~/tools/${ZIP%.*}/kse.sh ~/bin/kse.sh
popd

popd

