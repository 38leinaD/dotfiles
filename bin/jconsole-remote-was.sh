#!/bin/bash

export HOST=swpsws16
export IIOP_PORT=9811
export WAS_HOME=/home/daniel/IBM/WebSphere/AppServer


export PROVIDER=-Djava.naming.provider.url=corbaname:iiop:$HOST:$IIOP_PORT

export CLASSPATH=
export CLASSPATH=$CLASSPATH:$WAS_HOME/java/lib/tools.jar
export CLASSPATH=$CLASSPATH:$WAS_HOME/runtimes/com.ibm.ws.admin.client_8.5.0.jar
export CLASSPATH=$CLASSPATH:$WAS_HOME/runtimes/com.ibm.ws.ejb.thinclient_8.5.0.jar
export CLASSPATH=$CLASSPATH:$WAS_HOME/runtimes/com.ibm.ws.orb_8.5.0.jar
export CLASSPATH=$CLASSPATH:$WAS_HOME/java/lib/jconsole.jar

export URL=service:jmx:iiop://$HOST:$IIOP_PORT/jndi/JMXConnector

$WAS_HOME/java/bin/java -classpath $CLASSPATH $PROVIDER sun.tools.jconsole.JConsole $URL