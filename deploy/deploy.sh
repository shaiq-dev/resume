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

# # Deploy the build resume to S3
# pushd .
# cd src
# mv ./resume.pdf ./resume-${VERSION}.pdf
# aws s3 cp ./resume-${VERSION}.pdf s3://${S3_BUCKET}/resumes/
# popd

# # Deploy the stack
# STACK_NAME=dresume
# STACK_PARAMETERS="BucketName=${S3_BUCKET} LambdaCodeKey=lambda/dresume-${VERSION}.zip AllowedOrigins=${ALLOWED_ORIGINS}"
# STACK_TEMPLATE="deploy/stack.yml"

# aws cloudformation deploy --template-file ${STACK_TEMPLATE} --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM --stack-name ${STACK_NAME} --no-fail-on-empty-changeset --parameter-overrides ${STACK_PARAMETERS}