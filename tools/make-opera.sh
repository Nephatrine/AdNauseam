#!/usr/bin/env bash
#
# This script assumes a linux environment

hash jq 2>/dev/null || { echo; echo >&2 "Error: this script requires jq (https://stedolan.github.io/jq/), but it's not installed"; exit 1; }

echo "*** adnauseam.opera: Creating opera package"
echo "*** adnauseam.opera: Copying files"

DES=bin/build/adnauseam.opera

rm -r $DES
mkdir -p $DES

VERSION=`jq .version manifest.json` # new-manifest
UBLOCK=`jq .version platform/chromium/manifest.json | tr -d '"'` # ublock-version no quotes

bash ./tools/make-assets.sh $DES
bash ./tools/make-locales.sh $DES

cp -R src/css $DES/
cp -R src/img $DES/
cp -R src/js $DES/
cp -R src/lib $DES/

#mkdir -p $DES/_locales
#cp -R src/_locales/en $DES/_locales
#cp -R src/_locales/zh_CN $DES/_locales
#cp -R src/_locales/zh_TW $DES/_locales

cp src/*.html $DES/
cp platform/chromium/*.html $DES/
cp platform/chromium/*.js   $DES/js/
cp platform/chromium/*.json $DES/
cp -R platform/chromium/img $DES/
cp platform/opera/manifest.json $DES/  # adn: overwrites chromium manifest
cp LICENSE.txt $DES/

if sed --version >/dev/null 2>&1; then
  sed -i -e "s/\"{version}\"/${VERSION}/" $DES/manifest.json
  sed -i -e "s/{UBLOCK_VERSION}/${UBLOCK}/" $DES/popup.html
  sed -i -e "s/{UBLOCK_VERSION}/${UBLOCK}/" $DES/links.html
else
  sed -i '' "s/\"{version}\"/${VERSION}/" $DES/manifest.json
  sed -i '' "s/{UBLOCK_VERSION}/${UBLOCK}/" $DES/popup.html
  sed -i '' "s/{UBLOCK_VERSION}/${UBLOCK}/" $DES/links.html
fi

echo "*** adnauseam.opera: Package done."

if [ "$1" = all ]; then
    echo "*** adnauseam.opera: Creating package..."
    pushd $(dirname $DES/) > /dev/null
    zip artifacts/adnauseam.opera.zip -qr $(basename $DES/)/*
    popd > /dev/null
fi


#head $DES/manifest.json
