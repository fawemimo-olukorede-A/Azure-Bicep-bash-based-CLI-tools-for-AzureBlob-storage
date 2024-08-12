#!/bin/bash

GREEN="\033[0;32m"
RED="\033[31m"
DEFAULT="\033[0m"

function authenticate() {
    az login --use-device-code
}


#az account list-locations -output table 
function create_resource_group() {
    echo "let's create a resource group first!"
    read -p "Enter name of resource group: " resource_group
    read -p "Enter location: " location
    az group create \
       --name $resource_group \
        --location $location \

    if [ $? -eq 0 ]; then
      echo -e "${GREEN} Resource group created ${DEFAULT}"
    else 
      echo -e b"${RED} failed to create resource group ${DEFAULT}"
    fi
}



function create_storage_account() {
    echo "create a storage account!"
    read -p "Enter storage account name; " storage_account
    read -p "Enter resources group name: " resource_group
    read -p "Enter location: " location
    az storage account create \
       --name $storage_account \
       --resource-group $resource_group \
       --location $location \
        --sku Standard_LRS 

    if [ $? -eq 0 ]; then 
      echo -e "${GREEN} storage account created ${DEFAULT}"
    else 
      echo -e "${RED} storage account failed ${DEFAULT}"
    fi
}



function create_container() {
    echo "Create a container!"
    read -p "Enter container name: " container
    read -p "Enter storage account name: " storage_account
    az storage container create \
      --name $container \
      --account-name $storage_account 

    if [ $? -eq 0 ]; then 
       echo -e "${GREEN} container created ${DEFAULT}"
    else 
       echo -e "${RED} container creation  failed ${DEFAULT}"
    fi
}



function upload() {
    echo "upload your file!"
    read -p "Enter storage account name: " storage_account_name
    read -p "Enter container name: " container_name
    read -p "Enter name of file as it would be stored in azure blob: " file_name
    read -p "Enter path to the file as stored in your pc: " path_to_file

    az storage blob upload \
        --account-name $storage_account_name \
        --container-name $container_name \
        --name $file_name \
        --file $path_to_file \
        --account key ""
        
     if [ $? -eq 0]; then 
       echo -e "${GREEN} upload successful ${DEFAULT}"
    else 
       echo -e "${RED} upload failed ${DEFAULT}"
    fi
}

authenticate
create_resource_group
create_storage_account
create_container
upload

