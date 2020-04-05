#!/bin/bash

bash ./build_dmg.sh
mkdir $1
mv menuffy.dmg $1
../../Sparkle/bin/generate_appcast $1
cp $1/appcast.xml ./
