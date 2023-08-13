#!/bin/bash

set -euo pipefail

while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--version)
            VERSION="$2"
            shift # argument
            shift # value
            ;;
        -o|--origins)
            ALLOWED_ORIGINS="$2"
            shift # argument
            shift # value
            ;;
        -b|--bucket)
            S3_BUCKET="$2"
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

pushd .
cd handlers
zip -r dresume-${VERSION}.zip index.js
aws s3 cp ./dresume-${VERSION}.zip s3://${S3_BUCKET}/lambda/
popd

# Deploy the build resume to S3
pushd .
cd src
mv ./resume.pdf ./resume-${VERSION}.pdf
aws s3 cp ./resume-${VERSION}.pdf s3://${S3_BUCKET}/resumes/
popd

# Deploy the stack
STACK_NAME=dresume
STACK_PARAMETERS="BucketName=${S3_BUCKET} LambdaCodeKey=lambda/dresume-${VERSION}.zip AllowedOrigins=${ALLOWED_ORIGINS}"
STACK_TEMPLATE="deploy/stack.yml"

aws cloudformation deploy --template-file ${STACK_TEMPLATE} --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM --stack-name ${STACK_NAME} --no-fail-on-empty-changeset --parameter-overrides ${STACK_PARAMETERS}