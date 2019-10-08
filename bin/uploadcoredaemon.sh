#!/bin/bash

: ${2?Need two arguments}

DAEMON=$1
VERSION=$2

cp src/${DAEMON}d    ~/bin/${DAEMON}d-$VERSION
cp src/$DAEMON-cli   ~/bin/$DAEMON-cli-$VERSION
cp src/$DAEMON-tx    ~/bin/$DAEMON-tx-$VERSION
cp src/qt/$DAEMON-qt ~/bin/$DAEMON-qt-$VERSION
