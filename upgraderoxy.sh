#!/bin/bash

# Find latest temporary directory
T=${TMPDIR}upgraderoxy

# Find application folder - -d option or PWD
O=$PWD

# make new temp folder
mkdir $T

# Fetch latest MLJS download tar.gz file
cd $T
wget -nd --no-check-certificate https://codeload.github.com/marklogic/roxy/zip/dev

# Unpack in to new temp folder
unzip dev
cd roxy-dev 

# Copy relevant files
cp -r deploy/* $O/deploy
cp -r src/roxy/* $O/src/roxy
cp ml $O/ml
cp ml.bat $O/ml.bat
cp version.txt $O/version.txt
cp CHANGELOG.mdown $O/CHANGELOG.mdown

# delete temp folder
cd $O
rm -rf $T

# Print instructions for adding script and css links in to HTML

# Exit successfully
echo "Done."
exit 0
