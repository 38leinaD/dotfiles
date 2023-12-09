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

tasks.register("getSourceZip") {
    doLast {
        def (g,a,v) = "$2".split(':');

        def component =  project
                .configurations
                .runtimeClasspath
                .incoming
                .resolutionResult
                .allDependencies
                .collect { it.selected.id }
                .find { it.getGroup().equals(g) && it.getModule().equals(a) && it.getVersion().equals(v)}

        project.dependencies.createArtifactResolutionQuery()
        .forComponents([component])
        .withArtifacts(JvmLibrary, SourcesArtifact) // JavadocArtifact,SourcesArtifact
        .execute()
        .resolvedComponents
        .forEach {
            def javadocPath = it.artifactResults.iterator().next().getFile().toString()
            println javadocPath   
        }        
    }
}

EOF

(cd $tmp_dir && gradle $1 --console=plain --quiet)