#!/bin/bash

# !!! Set appropriate variables
bucketname=sergiochoo-wordpress-tfstate
region=eu-central-1
## end of vars section

# create bucket
aws s3api create-bucket --bucket $bucketname --region $region \
    --create-bucket-configuration LocationConstraint=$region

# enable bucket versioning
aws s3api put-bucket-versioning --bucket $bucketname --versioning-configuration Status=Enabled

# enable bucket encryption
aws s3api put-bucket-encryption \
    --bucket $bucketname \
    --server-side-encryption-configuration '{"Rules": [{"ApplyServerSideEncryptionByDefault": {"SSEAlgorithm": "AES256"}}]}'