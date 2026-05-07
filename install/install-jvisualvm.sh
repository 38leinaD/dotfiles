#!/bin/bash
set -e

#https://github.com/oracle/visualvm/releases/download/2.1.7/visualvm_217.zip
DOWNLOAD_PATH="https://github.com/oracle/visualvm/releases/download/2.1.7/visualvm_217.zip"
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
ln -s ~/tools/${FILENAME%%.*}/bin/visualvm ~/bin/visualvm
popd

popd

