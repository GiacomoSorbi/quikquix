#!/bin/bash


export AWS_DEFAULT_REGION=eu-west-1

# Will deploy an AWS S3 storage bucket. This is where the Terraform will store its state (references to what AWS resources it has created)
aws s3 mb s3://quikquix-ci-tfstate