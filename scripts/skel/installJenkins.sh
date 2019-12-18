#!/bin/bash

export JENKINS_USER=$(cat creds.json | jq -r '.jenkinsUser')
export JENKINS_PASSWORD=$(cat creds.json | jq -r '.jenkinsPassword')
export GITHUB_PERSONAL_ACCESS_TOKEN=$(cat creds.json | jq -r '.githubPersonalAccessToken')
export GITHUB_USER_NAME=$(cat creds.json | jq -r '.githubUserName')
export GITHUB_USER_EMAIL=$(cat creds.json | jq -r '.githubUserEmail')
#export DT_TENANT_ID=$(cat creds.json | jq -r '.dynatraceTenant')
export DT_TENANT=$(cat creds.json | jq -r '.dynatraceTenant')
export DT_API_TOKEN=$(cat creds.json | jq -r '.dynatraceApiToken')
export GITHUB_ORGANIZATION=$(cat creds.json | jq -r '.githubOrg')
export DT_TENANT_URL="https://$DT_TENANT"

echo "Creating PersistentVolumeClaim for Jenkins ..."
kubectl create -f manifests-jenkins/k8s-jenkins-pvcs.yml

export REGISTRY_URL=$(kubectl describe svc docker-registry -n cicd | grep IP: | sed 's~IP:[ \t]*~~')
if [ "$REGISTRY_URL" == "" ]; then
    echo "Service for Docker Registry could not be found. Please make sure the service has been deployed."
    exit 1
fi

echo "REGISTRY_URL:" $REGISTRY_URL

# Create Jenkins
rm -f manifests-jenkins/gen/k8s-jenkins-deployment.yml

cat manifests-jenkins/k8s-jenkins-deployment.yml | \
  sed 's~GITHUB_USER_EMAIL_PLACEHOLDER~'"$GITHUB_USER_EMAIL"'~' | \
  sed 's~GITHUB_ORGANIZATION_PLACEHOLDER~'"$GITHUB_ORGANIZATION"'~' | \
  sed 's~DOCKER_REGISTRY_IP_PLACEHOLDER~'"$REGISTRY_URL"'~' | \
  sed 's~DT_TENANT_URL_PLACEHOLDER~'"$DT_TENANT_URL"'~' | \
  sed 's~DT_API_TOKEN_PLACEHOLDER~'"$DT_API_TOKEN"'~' >> manifests-jenkins/gen/k8s-jenkins-deployment.yml

kubectl create -f manifests-jenkins/gen/k8s-jenkins-deployment.yml
kubectl create -f manifests-jenkins/k8s-jenkins-rbac.yml