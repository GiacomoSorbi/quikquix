#!/bin/bash

export AWS_DEFAULT_REGION=eu-west-1

# Destroy the S3 bucket

aws s3 rb s3://quikquix-ci-tfstate

echo "Bucket s3://quikquix-ci-tfstate removed"