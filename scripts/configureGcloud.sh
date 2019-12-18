#!/bin/bash

# Prerequisites:
# - user account acllab* exists on bastion host
# - a service account key file that was generated with the 'createGcloudServiceAccounts.sh' lies in the users home directory
# - a GKE clusters is running and you know the zone in which the cluster runs, e.g. 'us-central1-a'
#
# Steps:
# - ssh into user account and then execute this file with two parameters
# - make sure the project name at the end of the command is correct
# 
# Example:
# - for user acllab14 where the cluster runs in us-central1-a the command would be:
#
# $ ./configureGcloud.sh 14 us-central1-a

if [ -z $1 ]
then
    echo "Please provide the running number of the user as first parameter"
    echo ""
    echo "$ ./configureGcloud.sh 14 dynatrace us-central1-a detroit-acl-v2"
    exit 1
fi

if [ -z $2 ]
then
    echo "Please provide the standard password for the users as second parameter"
    echo ""
    echo "$ ./configureGcloud.sh 14 dynatrace us-central1-a detroit-acl-v2"
    exit 1
fi

if [ -z $3 ]
then
    echo "Please provide the zone as a third parameter"
    echo ""
    echo "$ ./configureGcloud.sh 14 dynatrace us-central1-a detroit-acl-v2"
    exit 1
fi

if [ -z $4 ]
then
    echo "Please provide the project as a fourth parameter"
    echo ""
    echo "$ ./configureGcloud.sh 14 dynatrace us-central1-a detroit-acl-v2"
    exit 1
fi

if [ -z $5 ]
then
    echo "Please provide the lab prefix as a fifth parameter"
    echo ""
    echo "$ ./configureGcloud.sh 14 dynatrace us-central1-a detroit-acl-v2 det-nov"
    exit 1
fi

if [ -z $6 ]
then
    echo "Please provide the username base as a sixth parameter"
    echo ""
    echo "$ ./configureGcloud.sh 14 dynatrace us-central1-a detroit-acl-v2 det-nov acllab"
    exit 1
fi


numberofusers=$1
password=$2
zone=$3
project=$4
prefix=$5
usernamebase=$6


i=1
while [ $i -le $numberofusers ]
do
    echo "configure gcloud cli for user $usernamebase$i"
    sudo -u $usernamebase$i -p $password -H gcloud auth activate-service-account --key-file=/home/$usernamebase$i/$prefix-$usernamebase$i-key.json
    sudo -u $usernamebase$i -p $password -H gcloud container clusters get-credentials $prefix-$usernamebase$i --zone $zone --project $project
    i=$((i+1))
done
