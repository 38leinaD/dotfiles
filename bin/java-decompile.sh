#!/bin/bash

rm -rf unpacked || true
mkdir unpacked

cp=$(gradle-resolve.sh getClasspath org.vineflower:vineflower:1.9.3)

while read -r jar
do
	echo "! $jar"
    java -jar $cp -bsm=1 $jar unpacked/$(basename $jar)-source.zip
    unzip -d unpacked/$(basename $jar) unpacked/$(basename $jar)-source.zip

done < <(find . -name "*-wf-*.jar")