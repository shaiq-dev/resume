#!/bin/bash

set -euo pipefail

VERSION=$(git rev-parse --short HEAD)
BUCKET=shaiq-resume-storage

# Install aws cli (R2 is S3 compatible)
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

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