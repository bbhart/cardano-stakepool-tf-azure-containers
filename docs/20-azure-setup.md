Azure Setup
===========

1. In the **files** directory, open **envvars** and modify the LOCATION and NONCE variables to your liking.
1. Run the `01-azure-init.sh` script:
    * `sh 01-azure-init.sh`
1. Edit **init.tf** and modify to match what's created in Azure.
1. Run: `terraform init`
1. Run: `terraform apply`


