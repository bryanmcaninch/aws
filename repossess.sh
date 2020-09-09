#!/usr/bin/env bash

# AWS Region (defaults to us-east-1)
regionID=""

# AWS ECR ID
registryID=""

# Repo "sub-directory"
subDirectory="modules"

for repo in `aws ecr describe-repositories --region=${regionID} | jq -r 'map(.[] | .repositoryName ) | join(" ")'`; do
  for image in `aws ecr list-images --region=${regionID} --repository-name ${repo} | jq -r 'map(.[] | .imageTag) | join(" ")'`; do
    aws ecr create-repository --region=${regionID} --repository-name ${subDirectory}/${repo};
    docker pull ${registryID}.dkr.ecr.${regionID}.amazonaws.com/${repo}:${image};
    docker tag ${registryID}.dkr.ecr.${regionID}.amazonaws.com/${repo}:${image} ${registryID}.dkr.ecr.${regionID}.amazonaws.com/${subDirectory}/${repo}:${image};
    docker push ${registryID}.dkr.ecr.${regionID}.amazonaws.com/modules/${repo}:${image};
  done;
done
