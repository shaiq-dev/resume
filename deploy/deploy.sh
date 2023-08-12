#!/bin/bash

set -euo pipefail

while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--version)
            VERSION="$2"
            shift # argument
            shift # value
            ;;
        *)
            echo "Error: Invalid command line argument $1"
            exit 255
            ;;
    esac
done


# For creating the lambda, cloudformation requires the lambbda code.
# We will deploy the lambda code first to an S3 bucket and later
# refrence it from the cloudformation template.
# $S3_BUCKET - env to store the bucket name

pushd .
cd handlers
zip -r dresume.zip index.js
aws s3 cp ./dresume.zip s3://${S3_BUCKET}/lambda
popd

# Deploy the build resume to S3
pushd .
cd src
mv ./resume.pdf ./resume-${VERSION}.pdf
popd

# Deploy the stack
STACK_NAME=dresume
STACK_PARAMETERS="BucketName=${S3_BUCKET},LambdaCodeKey=lambda/dresume.zip"
STACK_TEMPLATE="deploy/stack.yml"

aws cloudformation deploy --template-file ${STACK_TEMPLATE} --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM --stack-name ${STACK_NAME} --no-fail-on-empty-changeset --parameters ${STACK_PARAMETERS} 