#!/usr/bin/env bash

YLW='\033[1;33m'
NC='\033[0m'

#check if 'hub' command is installed
type hub &> /dev/null

if [ $? -ne 0 ]
    then
    echo "Please install the 'hub' command: https://hub.github.com/"
    exit 1
fi

#check if 'jq' command is installed
type jq &> /dev/null

if [ $? -ne 0 ]
    then
    echo "Please install the 'jq' command: https://stedolan.github.io/jq/"
    exit 1
fi

GITHUB_USER=$(cat creds.json | jq -r '.githubUserName')
GITHUB_EMAIL=$(cat creds.json | jq -r '.githubUserEmail')
GITHUB_TOKEN=$(cat creds.json | jq -r '.githubPersonalAccessToken')
GITHUB_ORG=$(cat creds.json | jq -r '.githubOrg')
HTTP_RESPONSE=$(curl -s -o /dev/null -I -w "%{http_code}" https://github.com/${GITHUB_ORG})

if [ $HTTP_RESPONSE -ne 200 ]
then
    echo "GitHub organization doesn't exist - https://github.com/${GITHUB_ORG} - HTTP status code $HTTP_RESPONSE"
    exit 1
fi

#create ~/.config/hub file required for authentication
echo -e $"github.com:\n- user: ${GITHUB_USER}\n  oauth_token: ${GITHUB_TOKEN}\n  protocol: https" > ~/.config/hub

#create array with acl-sockshop org repos
repositories=( $(curl -s https://api.github.com/orgs/acl-sockshop/repos | jq -r '.[].name') )

if [ ${#repositories[@]} -eq 0 ]
then
    echo "No Github repositories found in organization"
    exit 1
fi

mkdir repositories
cd repositories

for repo in "${repositories[@]}"
do
    echo -e "${YLW}Cloning https://github.com/acl-sockshop/${repo} ${NC}"
    git clone -q "https://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/acl-sockshop/${repo}"
    cd ${repo}
    echo -e "${YLW}Forking ${repo} to ${GITHUB_ORG} ${NC}"
    hub fork --org=${GITHUB_ORG}
    cd ..
    echo -e "${YLW}Done. ${NC}"
done

cd ..
rm -rf repositories
mkdir repositories
cd repositories

for repo in "${repositories[@]}"
do
    TARGET_REPO="http://${GITHUB_USER}:${GITHUB_TOKEN}@github.com/${GITHUB_ORG}/${repo}"
    echo -e "${YLW}Cloning http://github.com/${GITHUB_ORG}/${repo} ${NC}"
    git clone -q $TARGET_REPO
    echo -e "${YLW}Done. ${NC}"
done