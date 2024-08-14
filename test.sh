#!/bin/bash
read -p "location of the domain folder eg:/almfra354p/qc" location_to_domain_folder
# Prompt for domain name
read -p "Domain name: " domain

# Prompt for the total number of projects
read -p "Number of projects: " total_number_of_projects

# Initialize an array to store S3 URLs
s3_urls=()

# Loop to collect S3 URLs
for ((i = 0; i < total_number_of_projects; i++)); do
        read -p "$((i+1)) S3 URL for this domain: " s3_url
    s3_urls+=("$s3_url")
done

# Print the array of S3 URLs
echo "S3 URLs: ${s3_urls[@]}"

# Extract and print the project names from the S3 URLs
for s3_url in "${s3_urls[@]}"; do
    cd $location_to_domain_folder/$domain* || { echo "Directory not found"; exit 1; }
    pwd
    project_name=$(basename "$s3_url")
    echo "#############  downloading the $project_name   #################"
    echo "Project name: $project_name"
    aws s3 cp "$s3_url" .
    echo "#############  download completed successfuly: $project_name  ###############"
    echo "##3###########  changing the owner of the file or folder root to ubuntu: $project_name  #####################"
    sudo chown -R ubuntu:ubuntu $project_name
    echo "#############  owner changed to ubuntu: $project_name ##################"
    echo "############ giving 777 permission to the file or folder: $project_name  #################"
    sudo chmod 777 $project_name -R
    echo "############ done to giving 777 permission to the file or folder: $project_name  #############"
    echo "################ start to unzip the file or folder: $project_name  ##########################"
    sudo nohup unzip $project_name
    echo "############### unzip completed: $project_name ########################"
    folder_name="${project_name%.zip}"
    echo "############### getting size of the unziped file or folder: $folder_name ##############"

    #du -sh $folder_name
    echo "######## size of the unziped file or folder: $(du -sh $folder_name) #################"
    echo "###########  changing the owner of the file or folder root to ubuntu: $folder_name ###############"
    sudo chown -R ubuntu:ubuntu $folder_name
    echo "################  owner changed to ubuntu: $folder_name  #################"
    echo "################  giving 777 permission to the file or folder: $folder_name  #################"
    sudo chmod 777 $folder_name -R
    echo "##############  done to giving 777 permission to the file or folder: $folder_name   ####################"


    ls -la
    echo "################ removing the zip file from the folder: $project_name #####################"
    sudo rm -rf $project_name
    ls -la
done