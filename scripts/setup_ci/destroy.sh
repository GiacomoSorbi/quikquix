#!/bin/bash

export AWS_DEFAULT_REGION=eu-west-1

terraform destroy -auto-approve

# Destroy the S3 bucket. Needs '--force' because the bucket will potentially have files (tfstate)

aws s3 rb s3://quikquix-ci-tfstate --force

echo "Bucket s3://quikquix-ci-tfstate removed"