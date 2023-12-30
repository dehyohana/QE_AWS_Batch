#!/bin/bash

# AWS Batch job name
JOB_NAME="qe-fargate-job-v3"

# AWS Batch job definition and revision
JOB_DEFINITION="my-project-job-definition"
JOB_REVISION="3"

# AWS Batch job queue
JOB_QUEUE="my-project-job-queue-example"

# Secret name in AWS Secrets Manager
SECRET_NAME="terraform_user"

# Fetch AWS credentials from Secrets Manager
AWS_CREDS=$(aws secretsmanager get-secret-value --secret-id arn:aws:secretsmanager:us-east-1:244883884162:secret:terraform_user-RJI5cn --query SecretString --output text)

# Additional configuration for running pw.x inside the container
# Container overrides for running pw.x with mpirun
CONTAINER_OVERRIDES='{
  "command": ["mpirun", "-np", "2", "/opt/qe-6.8/bin/pw.x", "-in", "/workdir/input.in", "> /workdir/output.out"],
  "environment": [
    {"name": "AWS_ACCESS_KEY_ID", "value": "'$(echo $AWS_CREDS | jq -r .AWS_ACCESS_KEY_ID)'"},
    {"name": "AWS_SECRET_ACCESS_KEY", "value": "'$(echo $AWS_CREDS | jq -r .AWS_SECRET_ACCESS_KEY)'"},
    {"name": "AWS_DEFAULT_REGION", "value": "'$(echo $AWS_CREDS | jq -r .AWS_DEFAULT_REGION)'"}
  ],
  "resourceRequirements": [
  {
    "type": "VCPU",
    "value": "1.0"
  },
  {
    "type": "MEMORY",
    "value": "2048"  
  }
  ]
}'

# AWS CLI command to submit the job
aws batch submit-job \
  --job-name $JOB_NAME \
  --job-definition $JOB_DEFINITION:$JOB_REVISION \
  --job-queue $JOB_QUEUE \
  --container-overrides "$CONTAINER_OVERRIDES"

