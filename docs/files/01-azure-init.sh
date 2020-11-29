#!/bin/bash


# Source the environment
source ./envvars

echo "LOCATION is ${LOCATION}"
if [ -z "$LOCATION" ]; then
    echo "envvars not read correctly. Exiting..."
    exit 1
fi

# Create resource group
echo "Creating group ${RESOURCE_GROUP_NAME} in ${LOCATION}..."
az group create --name $RESOURCE_GROUP_NAME --location ${LOCATION}

# Create keyvault
echo "Creating keyvault ${KEYVAULTNAME} if it doesn't exist..."
az keyvault create --name ${KEYVAULTNAME} --resource-group ${RESOURCE_GROUP_NAME} --location ${LOCATION}

# Create storage account
echo "Creating storage account ${STORAGE_ACCOUNT_NAME}..."
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Get storage account key
echo "Fetching storage account key..."
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

# Create blob container
echo "Create blog container ${CONTAINER_NAME} in ${STORAGE_ACCOUNT_NAME}..."
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY

# Put Storage Account Key in keyvault
echo "Stashing Storage Account key in keyvault ${KEYVAULTNAME}..."
az keyvault secret set --vault-name ${KEYVAULTNAME} --name "SAKEY" --value "${ACCOUNT_KEY}"

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"

echo "Done"