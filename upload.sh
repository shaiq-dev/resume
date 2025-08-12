#!/bin/bash

set -euo pipefail

version=$(git rev-parse --short=8 HEAD)
bucket=shaiq-resume-storage

# aws cli is pre installed in github hosted runners
# R2 is S3 API compatible
aws configure set aws_access_key_id $CLOUDFLARE_R2_ACCESS_KEY_ID
aws configure set aws_secret_access_key $CLOUDFLARE_R2_SECRET_ACCESS_KEY
aws configure set default.region auto

pushd .
cd src
mv ./resume.pdf ./resume-${version}.pdf

aws s3 cp ./resume-${version}.pdf s3://${bucket}/archive/ --endpoint-url $CLOUDFLARE_R2_ENDPOINT

# Override the latest version
aws s3 cp ./resume-${version}.pdf s3://${bucket}/latest-resume.pdf --endpoint-url $CLOUDFLARE_R2_ENDPOINT
popd