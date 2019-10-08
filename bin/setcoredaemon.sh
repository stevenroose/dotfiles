#!/bin/bash

: ${2?Need two arguments}

DAEMON=$1
VERSION=$2

rm ~/bin/${DAEMON}d
ln -s ~/bin/${DAEMON}d-$VERSION  ~/bin/${DAEMON}d
rm ~/bin/$DAEMON-cli
ln -s ~/bin/$DAEMON-cli-$VERSION ~/bin/$DAEMON-cli
rm ~/bin/$DAEMON-tx
ln -s ~/bin/$DAEMON-tx-$VERSION  ~/bin/$DAEMON-tx
rm ~/bin/$DAEMON-qt
ln -s ~/bin/$DAEMON-qt-$VERSION  ~/bin/$DAEMON-qt
