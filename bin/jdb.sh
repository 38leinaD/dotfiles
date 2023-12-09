#!/bin/bash
set -e

if [ ! $# -eq 2 ]; then
	echo "Sets up the soources for debuging and runs/connects jdb to a Java process (port 8787)."
	echo "It can either decompile the jar and provide the decompiled sources as input to jdb or download the source.zip."
	echo "usage: $(basename $0) decompile|sourceZip <groupid:artifactid:version>"
	exit 1

fi

WORK_DIR=$(mktemp -d)

#WORK_DIR=`mktemp -d`
echo "Tmp dir for sources: $WORK_DIR"

if [[ "$1" == "decompile" ]]; then
	java -jar $(gradle-resolve.sh getClasspath org.vineflower:vineflower:1.9.3) -bsm=1 $(gradle-resolve.sh getJar $2) $WORK_DIR
else
	unzip -d $WORK_DIR $(gradle-resolve.sh getSourceZip $2)
fi

jdb -sourcepath $WORK_DIR -attach 8787