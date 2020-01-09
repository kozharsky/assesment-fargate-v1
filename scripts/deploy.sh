#!/bin/bash
set -e

ANSIBLE_FILES=./scripts/ansible.tar.gz
TERRAFORM_INIT=./.terraform
TERRAFORM_FILES=./terraform/aws

if [ -f "${ANSIBLE_FILES}" ]; then
  rm -f ./scripts/ansible.tar.gz
fi

tar -czvf ./scripts/ansible.tar.gz ./scripts/ansible

if [ ! -d "${TERRAFORM_INIT}" ]; then
  terraform init terraform/aws
else
  echo "init stage was passed"
fi


terraform apply -state=${TERRAFORM_FILES}/terraform.tfstate terraform/aws

echo "The application will be available in a couple of minutes"