#!/usr/bin/env bash
#
# This script assumes a linux environment

echo "*** adnauseam.chromium: Creating chrome package"
echo "*** adnauseam.chromium: Copying files"

DES=bin/build/adnauseam.chromium
rm -rf $DES
mkdir -p $DES

UBLOCK=`jq .version platform/chromium/manifest.json | tr -d '"'` # ublock-version

bash ./tools/make-assets.sh $DES
bash ./tools/make-locales.sh $DES

cp -R src/css               $DES/
cp -R src/img               $DES/
cp -R src/js                $DES/
cp -R src/lib               $DES/
#cp -R src/_locales          $DES/
#cp -R $DES/_locales/nb      $DES/_locales/no
cp src/*.html               $DES/
cp platform/chromium/*.js   $DES/js/
cp -R platform/chromium/img $DES/
cp platform/chromium/*.html $DES/
cp platform/chromium/*.json $DES/
cp manifest.json $DES/            # new-manifest
cp LICENSE.txt              $DES/

if sed --version >/dev/null 2>&1; then
  sed -i -e "s/{UBLOCK_VERSION}/${UBLOCK}/" $DES/popup.html
  sed -i -e "s/{UBLOCK_VERSION}/${UBLOCK}/" $DES/links.html
else
  sed -i '' "s/{UBLOCK_VERSION}/${UBLOCK}/" $DES/popup.html
  sed -i '' "s/{UBLOCK_VERSION}/${UBLOCK}/" $DES/popup.html
fi

if [ "$1" = all ]; then
    echo "*** adnauseam.chromium: Creating package..."
    pushd $(dirname $DES/) > /dev/null
    zip artifacts/adnauseam.chromium.zip -qr $(basename $DES/)/*
    popd > /dev/null
fi

echo "*** adnauseam.chromium: Package done."

#ls -lR $DES
#cat $DES/popup.html | less
