#!/bin/bash

set -euo pipefail

VERSION=$(git rev-parse --short HEAD)
BUCKET=shaiq-resume-storage

# aws cli is pre installed in github hosted runners
# R2 is S3 API compatible
aws configure set aws_access_key_id $CLOUDFLARE_R2_ACCESS_KEY_ID
aws configure set aws_secret_access_key $CLOUDFLARE_R2_SECRET_ACCESS_KEY
aws configure set default.region auto

pushd .
cd src
mv ./resume.pdf ./resume-${VERSION}.pdf

aws s3 cp ./resume-${VERSION}.pdf s3://${BUCKET}/archive/ --endpoint-url $CLOUDFLARE_R2_ENDPOINT

# Override the latest version
aws s3 cp ./resume-${VERSION}.pdf s3://${BUCKET}/latest-resume.pdf --endpoint-url $CLOUDFLARE_R2_ENDPOINT
popd