#!/bin/bash

# A simple script to apply Terraform configurations in sequence with auto-approval.

# Set the script to exit immediately if any command exits with a non-zero status.
set -e

# Apply Terraform configuration for the VPC Module.
cd D:/eks-with-terraform/eks/vpc-module
echo "Applying Terraform for the VPC module..."
sleep 3
terraform apply -auto-approve

# Check if the previous command was successful.
if [ $? -eq 0 ]; then
    echo "Successfully applied Terraform for the root module, moving to eks-module..."
    sleep 3
    cd ../eks-module/
    
    # Apply Terraform configuration for the eks-module.
    terraform apply -auto-approve

    # Check if the previous command was successful.
    if [ $? -eq 0 ]; then
        echo "Successfully created the eks cluster, moving to iam-roles-module..."
        sleep 3
        cd ../iam-roles-module/
        
        # Apply Terraform configuration for the iam-roles-module.
        terraform apply -auto-approve
        echo "Successfully applied Terraform for iam-roles-module."
    else
        echo "Failed to apply Terraform for eks-module."
        exit 1
    fi
else
    echo "Failed to create the VPC......exiting......"
    exit 1
fi
