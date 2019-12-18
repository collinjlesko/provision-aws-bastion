#!/bin/bash

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>>/tmp/gcloud-renew-gke-login-log.out 2>&1

### Script to renew GKE login configurations ###
# This script was added to root crontab during acl provisioning.
# Everything below will go to the file 'gcloud-renew-gke-login-log.out' on the /tmp directory

YLW='\033[1;33m'
NC='\033[0m'
CURRENT_DATE=$(date)
GRN='\033[0;32m'

numberofusers=$1
gcp_zone=$2
gcp_project=$3
prefix=$4
base=$5
password=$6

if [ -z $numberofusers ]; then
    echo "Please provide the number of users as first parameter"
    echo ""
    echo "$ ./gcloud-renew-gke-login.sh 5"
    exit 1
fi

if [ -z $gcp_zone ]; then
    echo "Please provide the gcp zone as the second parameter"
    echo ""
    echo "$ ./gcloud-renew-gke-login.sh 5 us-central1-a"
    exit 1
fi

if [ -z $gcp_project ]; then
    echo "Please provide the gcp project as the third parameter"
    echo ""
    echo "$ ./gcloud-renew-gke-login.sh 5 us-central1-a detroit-acl-v2"
    exit 1
fi

if [ -z $prefix ]; then
    echo "Please provide the lab prefix as the fourth parameter"
    echo ""
    echo "$ ./gcloud-renew-gke-login.sh 5 us-central1-a detroit-acl-v2 acl-det-oct19"
    exit 1
fi

if [ -z $base ]; then
    echo "Please provide the username base as the fifth parameter"
    echo ""
    echo "$ ./gcloud-renew-gke-login.sh 5 us-central1-a detroit-acl-v2 acl-det-oct19 acllab"
    exit 1
fi

if [ -z $password ]; then
    echo "Please provide the user's password as the sixth parameter"
    echo ""
    echo "$ ./gcloud-renew-gke-login.sh 5 us-central1-a detroit-acl-v2 acl-det-oct19 acllab userpassword"
    exit 1
fi

echo -e "${YLW}${CURRENT_DATE}${NC}"

echo "GCP zone: ${gcp_zone}"
echo "Project name: ${gcp_project}"
echo ""

# Loop through all acllab users and renew their GKE configuration
i=1
while [ $i -le $numberofusers ]
do
    echo -e "${GRN}Renewing GKE login for user ${base}${i}${NC}"
  sudo -u $base$i -p $password -H /snap/bin/gcloud auth activate-service-account --key-file=/home/$base$i/$prefix-$base$i-key.json
  sudo -u $base$i -p $password -H /snap/bin/gcloud container clusters get-credentials $prefix-$base$i --zone $gcp_zone --project $gcp_project
    echo ""
    i=$((i+1))
done

echo ""