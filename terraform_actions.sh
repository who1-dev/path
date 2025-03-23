#!/bin/bash

# Define an array with directories to process
DIRECTORIES=("network" "iam" "compute")

# Iterate over each directory
for dir in "${DIRECTORIES[@]}"; do
  echo "Processing directory: $dir"

  # Check if Terraform configuration exists in the directory
  if [ -f "$dir/main.tf" ] || [ -f "$dir/terraform.tf" ]; then
    cd "$dir" || { echo "Failed to enter $dir"; exit 1; }

    # Run Terraform commands
    echo "Running 'terraform fmt' in $dir..."
    terraform fmt -recursive || { echo "Error during 'terraform fmt'. Exiting."; exit 1; }

    echo "Running 'terraform validate' in $dir..."
    terraform validate || { echo "Validation failed in $dir. Exiting."; exit 1; }

    echo "Planning Terraform provisioning in $dir..."
    terraform plan --var-file=.tfvars|| { echo "Error during 'terraform apply'. Exiting."; exit 1; }

    echo "Applying Terraform in $dir..."
    terraform apply --var-file=.tfvars -auto-approve || { echo "Error during 'terraform apply'. Exiting."; exit 1; }


    # Return to the parent directory
    cd - || { echo "Failed to return to the parent directory"; exit 1; }
  else
    echo "Terraform configuration not found in $dir. Skipping."
  fi

  echo "Completed processing for $dir."
done

echo "All directories processed successfully!"