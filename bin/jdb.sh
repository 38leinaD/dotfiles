#!/bin/bash
set -e

if [[ "$1" == "" ]]; then
	echo "Provide the GAV of the Jar to debug. This will decompile it and provide the decompiled sources as input to jdb."
	echo "usage: $(basename $0) <groupid:artifactid:version>"
	exit 1
fi

WORK_DIR=/home/daniel/junk/test
rm -rf $WORK_DIR/*

#WORK_DIR=`mktemp -d`
echo "Working dir: $WORK_DIR"

java -jar $(gradle-resolve.sh getClasspath org.vineflower:vineflower:1.9.3) -bsm=1 $(gradle-resolve.sh getJar $1) $WORK_DIR

jdb -sourcepath $WORK_DIR -attach 8787