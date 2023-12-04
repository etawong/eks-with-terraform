#!/bin/bash

# A script to destroy Terraform configurations in reverse sequence with auto-approval.

# Set the script to exit immediately if any command exits with a non-zero status.
set -e


# Destroy Terraform configuration for the iam-roles-module.
cd D:/eks-with-terraform/eks/iam-roles-module
: <<'COMMENT'
echo "Destroying Terraform for the iam-roles-module..."
sleep 3
terraform destroy -auto-approve

# Check if the previous command was successful.
if [ $? -eq 0 ]; then
    echo "Successfully destroyed Terraform for the iam-roles-module, moving to eks-module..."
else
    echo "Failed to destroy the iam-roles-module......exiting......"
    exit 1
fi
COMMENT

sleep 3
cd ../eks-module/

# Destroy Terraform configuration for the eks-module.
terraform destroy -auto-approve

# Check if the previous command was successful.
if [ $? -eq 0 ]; then
    echo "Successfully destroyed the eks cluster, moving to VPC module..."
    sleep 3
    cd ../vpc-module/
    
    # Destroy Terraform configuration for the VPC Module.
    terraform destroy -auto-approve
    echo "Successfully destroyed the VPC module"
else
    echo "Failed to destroy Terraform for the eks-module."
    exit 1
fi
