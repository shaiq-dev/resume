#!/bin/bash

set -e

echo "Creating output directory $OUT_DIR..."
mkdir --parent $OUT_DIR

fileName="resume.tex"
echo "Substituting version number ${GITHUB_SHA::7} in file $fileName"
sed -i -e "s/version/${GITHUB_SHA::7}/" $fileName
echo "Converting file $fileName to pdf..."
xelatex $fileName
cp *.pdf $OUT_DIR 2>/dev/null || :