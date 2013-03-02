#!/bin/bash

SRC=~/Source
DEST=~/Build

function clone_github {
mkdir $SRC
cd $SRC
git clone git@github.com:edmunds/edmunds-configuration.git
git clone git@github.com:edmunds/automated-test.git
git clone git@github.com:edmunds/etm-agent.git
git clone git@github.com:edmunds/etm-api.git
git clone git@github.com:edmunds/etm-client.git
git clone git@github.com:edmunds/etm-core.git
git clone git@github.com:edmunds/zookeeper-common.git
}

function do_sync {
p4 sync /perforce/edmunds/libraries/automated-test/main/...
p4 sync /perforce/edmunds/libraries/configuration/...
p4 sync /perforce/edmunds/libraries/etm-common/...
p4 sync /perforce/edmunds/services/etm-agent/main/...
p4 sync /perforce/edmunds/libraries/etm-client/main/...
p4 sync /perforce/edmunds/services/etm/main/...
p4 sync /perforce/edmunds/libraries/zookeeper-common/main/...
}

function copy_code {
rm -rf $DEST
cp -r $SRC $DEST

find $DEST -name "*.java" | xargs rm

cp -r /perforce/edmunds/libraries/automated-test/main/src $DEST/automated-test

cp -r /perforce/edmunds/libraries/configuration/configuration-common/main/src $DEST/edmunds-configuration
cp -r /perforce/edmunds/libraries/configuration/configuration-dns/main/src $DEST/edmunds-configuration

cp -r /perforce/edmunds/services/etm-agent/main/src $DEST/etm-agent

cp -r /perforce/edmunds/libraries/etm-common/main/src $DEST/etm-api/etm-common
cp -r /perforce/edmunds/services/etm/main/etm-loadbalancer-api/src $DEST/etm-api/etm-loadbalancer-api

cp -r /perforce/edmunds/libraries/etm-client/main/etm-client-core/src $DEST/etm-client/etm-client-core
cp -r /perforce/edmunds/libraries/etm-client/main/etm-client-impl/src $DEST/etm-client/etm-client-impl

cp -r /perforce/edmunds/services/etm/main/etm-controller/src $DEST/etm-core/etm-controller
cp -r /perforce/edmunds/services/etm/main/etm-dummy-loadbalancer/src $DEST/etm-core/etm-dummy-loadbalancer
cp -r /perforce/edmunds/services/etm/main/etm-url-token-tool/src $DEST/etm-core/etm-url-token-tool

cp -r /perforce/edmunds/libraries/zookeeper-common/main/src $DEST/zookeeper-common

chmod -R u+w $DEST

rm $DEST/etm-agent/src/main/resources/META-INF/install-chef.sh
rm $DEST/etm-client/etm-client-core/src/test/resources/testng.xml
rm $DEST/etm-core/etm-dummy-loadbalancer/src/test/resources/testng.xml
rm $DEST/etm-core/etm-url-token-tool/src/test/resources/testng.xml
}

function build_all {

cd $DEST/automated-test
mvn clean install

cd $DEST/edmunds-configuration
mvn clean install

cd $DEST/zookeeper-common
mvn clean install

cd $DEST/etm-api
mvn clean install

cd $DEST/etm-agent
mvn clean install

cd $DEST/etm-client
mvn clean install

cd $DEST/etm-core
mvn clean install
}

clone_github

do_sync

copy_code

build_all
