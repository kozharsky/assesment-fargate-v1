#!/bin/bash
set -e

TERRAFORM_FOLDER=./terraform/aws
terraform destroy -state=${TERRAFORM_FOLDER}/terraform.tfstate terraform/aws
rm -f ./scripts/ansible.tar.gz ${TERRAFORM_FOLDER}/terraform.tfstate ${TERRAFORM_FOLDER}/terraform.tfstate.backup
rm -r ./.terraform

echo "All terraform init files have been deleted"