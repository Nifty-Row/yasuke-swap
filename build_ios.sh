#!/bin/bash
RC="`cat rc.txt`"
MAJOR_VERSION="`cat major_version.txt`"
MINOR_VERSION="`cat minor_version.txt`"
BASE_DIR=/Users/aardvocate/src/yasukeV3/mobile/yasuke

#MAJOR_VERSION=$((MAJOR_VERSION + 1))
#MINOR_VERSION=$((MINOR_VERSION + 1))
VERSION="v$MAJOR_VERSION.$MINOR_VERSION-rc$RC"

cd $BASE_DIR
echo "$VERSION"
echo "$RC" > rc.txt
echo "$MINOR_VERSION" > minor_version.txt
echo "$MAJOR_VERSION" > major_version.txt

CONSTANTS_FILE="constants.ts"
BAK_FILE="$CONSTANTS_FILE.bak"
WORKING_FILE="$CONSTANTS_FILE.work"

cd $BASE_DIR/src/pages/utils/
#back up constants.ts
cp $CONSTANTS_FILE $BAK_FILE
#make a working copy as well
#tail -n +1 prints the whole file
#tail -n +2 prints all file expect the first line
#tail -n +3 prints all file expect the first 2 lines

tail -n +16 $CONSTANTS_FILE > $WORKING_FILE
#add the server base url and the first line of file
echo 'import { keystore } from "eth-lightwallet";
import { StorageService } from "./storageservice";
import { Console } from "./console";
import { Headers } from "@angular/http";
import { networks, Network } from "bitcoinjs-lib";
import { LocalProps } from "./localprops";
import { CoinsSender } from "./coinssender";
import { HDNode } from "bitcoinjs-lib";
import { mnemonicToSeed } from "bip39";

export class Constants {
static TOMCAT_URL = "https://lb.yasuke.net";' > /tmp/temp
echo "static APP_VERSION = \"$VERSION\"" >> /tmp/temp
echo "static ENABLE_GUEST = false;" >> /tmp/temp
echo "static NOTIFICATION_SOCKET_URL = \"ws://ethereum.yasuke.net:8080/notify/websocket\";" >> /tmp/temp

cat /tmp/temp | cat - $WORKING_FILE > temp && mv temp $WORKING_FILE
mv $WORKING_FILE $CONSTANTS_FILE
cd $BASE_DIR

ionic cordova build ios --release

cd $BASE_DIR/src/pages/utils/
mv $BAK_FILE $CONSTANTS_FILE

cd $BASE_DIR
