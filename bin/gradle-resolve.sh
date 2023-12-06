#!/bin/bash

if [[ "$1" == "" ]]; then
    echo "Resolve an artifact by GAV and return path in local Gradle cache. Can return jar only or whole classpath."
    echo "usage: $(basename $0) getJar getJar|getClasspath <groupid:artifactid:version>"
    exit 1
fi

tmp_dir=$(mktemp -d)
cat << EOF > $tmp_dir/build.gradle
plugins {
    id 'java'
}

// Check if we have specific download repos defined in corporate environment
if (project.hasProperty('downloadRepositories')) {
    project.repositories project.downloadRepositories
}
else {
    project.repositories {
        mavenCentral()
    }
}

dependencies {
    implementation "$2"
}

tasks.register("getClasspath") { 
    doLast {
        println configurations.runtimeClasspath.join(':')
    }
}

tasks.register("getJar") { 
    doLast {
        println configurations.runtimeClasspath[0]
    }
}
EOF

(cd $tmp_dir && gradle $1 --console=plain --quiet)