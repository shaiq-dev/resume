#!/bin/bash

set -euo pipefail

VERSION=$(git rev-parse --short HEAD)

# Deploy the Bucket stack to store the lambda code
aws cloudformation deploy --template-file "deploy/stacks/storage.yml" --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM --stack-name resume-storage --no-fail-on-empty-changeset
BUCKET_NAME=$(aws cloudformation describe-stacks --stack-name resume-storage | jq --raw-output --arg OUTPUT_KEY BucketName '.Stacks[].Outputs[] | select(.OutputKey == $OUTPUT_KEY) | .OutputValue')

# Zip and upload the lambda to bucket
pushd .
cd handlers
zip -r resume-${VERSION}.zip index.js
aws s3 cp ./resume-${VERSION}.zip s3://${BUCKET_NAME}/lambda/
popd

# Upload resume to bucket
pushd .
cd src
mv ./resume.pdf ./resume-${VERSION}.pdf
aws s3 cp ./resume-${VERSION}.pdf s3://${BUCKET_NAME}/resume/
popd

# Deploy the Lambda stack
STACK_PARAMETERS="BucketName=${BUCKET_NAME} LambdaCodeKey=lambda/resume-${VERSION}.zip AllowedOrigins=*"
aws cloudformation deploy --template-file "deploy/stacks/lambda.yml" --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM --stack-name resume-lambda --no-fail-on-empty-changeset --parameter-overrides ${STACK_PARAMETERS}