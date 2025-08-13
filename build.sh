#!/bin/bash

# Exit on error
set -e

image="resume-builder"

# Main input latex file name
input="resume.tex"

# Append version to the resume if "__VERSION__" placeholder exists
sed -i -e "s/__VERSION__/$(git rev-parse --short=8 HEAD)/" $(pwd)/src/$input

docker build -t $image .
docker run --rm -v $(pwd)/src:/data $image pdflatex $input
