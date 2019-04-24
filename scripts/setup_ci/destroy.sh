#!/bin/bash

terraform init -input=false

terraform destroy -input=false -auto-approve

# Destroy the S3 bucket. Needs '--force' because the bucket will potentially have files (tfstate)

aws s3 rb s3://quikquix-tf --force

echo "Bucket s3://quikquix-ci-tfstate removed"