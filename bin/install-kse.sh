#!/bin/bash
set -e

#https://github.com/oracle/visualvm/releases/download/2.1.7/visualvm_217.zip
DOWNLOAD_PATH="https://github.com/kaikramer/keystore-explorer/releases/download/v5.5.3/kse-553.zip"
DOWNLOAD_DIR=~/Downloads

FILENAME=$(echo $DOWNLOAD_PATH | rev | cut -d'/' -f1 | rev)

pushd $DOWNLOAD_DIR

if ! [ -e $FILENAME ]; then
	curl -LO $DOWNLOAD_PATH
else
	echo "File $FILENAME already downloaded before. Reusing."
fi

pushd ~/tools/
unzip $DOWNLOAD_DIR/$FILENAME
mv ~/tools/${FILENAME%%.*} ~/tools/kse
ln -s ~/tools/kse/kse.sh ~/.local/bin/kse.sh
popd

popd

