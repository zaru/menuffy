#!/bin/bash

test -f menuffy.dmg && rm menuffy.dmg
test -f rw.menuffy.dmg && rm rw.menuffy.dmg
create-dmg \
  --volname "menuffy" \
  --background "./app/background@2x.png" \
  --window-pos 400 200 \
  --window-size 400 400 \
  --icon-size 128 \
  --icon "menuffy.app" 50 190 \
  --app-drop-link 240 190 \
  --hide-extension "menuffy.app" \
  "menuffy.dmg" \
  "./app/"
