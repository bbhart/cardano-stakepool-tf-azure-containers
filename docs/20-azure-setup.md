Azure Setup
===========

This document borrows heavily from [this blog post](https://blog.logrocket.com/real-world-azure-resource-management-with-terraform-and-docker/) 
by [Paul Cowan](https://blog.logrocket.com/author/paulcowan).

We'll be defining two environments: `stage` and `prod`. 

At the end of this chapter, we should have:
* An Azure resource group (RG)
* An Azure subscription
* An Azure storage account
* A storage key for the storage account
* A blob container in the storage account
* Two Azure keyvaults: one each for stage and prod
* Each keyvault will store:
    * `terraform-backend-key`
    * `state-storage-account-name`
    * `state-storage-container-name`
    * `my-subscription-id` (for easier access)
    * `sp-client-id`
    * `sp-client-secret`
* A service principal (SP)
* Dockerfile for terraform
* Docker image built from the Dockerfile

This will be automated over time. Perform all of these in the same terminal window, or else your variables will disappear.

1. [Create an Azure account](https://signup.azure.com/) if you don't have one already.
1. (optional) Consider creating a Subscription within Azure for your stakepool expenses. 
1. `az login`
1. List subscriptions: `az account list --output table`
1. If you have multiple subscriptions, set the one to use:
    `az account set --subscription "<name>"`
1. Create the resource group and storage account for TF:
```
# Change the NONCE below to be something else (your initials, a random number?) since 
# some of our resources have to have globally-unique names :| 
NONCE="bbhart"
SUBID=$(az account show -o tsv --query "id")
LOCATION="eastus2"
RG="cardano-tstate"
SA="tstate${NONCE}"
az group create --name ${RG} --location ${LOCATION}
az storage account create --resource-group ${RG} --name ${SA} --sku Standard_LRS --encryption-services blob
SA_KEY=$(az storage account keys list --resource-group ${RG} --account-name ${SA} --query "[0].value" -o tsv)
```
1. Create container, one per environment.
```
az storage container create --name tstatestage --account-name ${SA} --account-key ${SA_KEY}
az storage container create --name tstateprod --account-name ${SA} --account-key ${SA_KEY}
```
1. Create keyvaults, one per environment.
```
az keyvault create --name ${NONCE}-keyvault-stage --resource-group ${RG} --location ${LOCATION}
az keyvault create --name ${NONCE}-keyvault-prod --resource-group ${RG} --location ${LOCATION}
```
1. Populate keyvaults with data.
```
az keyvault secret set --vault-name ${NONCE}-keyvault-stage --name "terraform-backend-key" --value "${SA_KEY}"
az keyvault secret set --vault-name ${NONCE}-keyvault-stage --name "state-storage-account-name" --value "${SA}"
az keyvault secret set --vault-name ${NONCE}-keyvault-stage --name "state-storage-container-name" --value "tstate"
az keyvault secret set --vault-name ${NONCE}-keyvault-stage --name "my-subscription-id" --value "${SUBID}"

az keyvault secret set --vault-name ${NONCE}-keyvault-prod --name "terraform-backend-key" --value "${SA_KEY}"
az keyvault secret set --vault-name ${NONCE}-keyvault-prod --name "state-storage-account-name" --value "${SA}"
az keyvault secret set --vault-name ${NONCE}-keyvault-prod --name "state-storage-container-name" --value "tstate"
az keyvault secret set --vault-name ${NONCE}-keyvault-prod --name "my-subscription-id" --value "${SUBID}"
```
1. Create a service principal.
```
az ad sp create-for-rbac --role contributor --scopes "/subscriptions/$SUBID" --name http://myterraform --sdk-auth
```
1. From the output, add the clientID and clientSecret to the vaults.
```
az keyvault secret set --vault-name ${NONCE}-keyvault-stage --name "sp-client-id" --value "<the value>"
az keyvault secret set --vault-name ${NONCE}-keyvault-stage --name "sp-client-secret" --value "<the value>"
```
