#!/bin/sh

if [ -z $1 ]
then
    echo "Please provide the number of users as first parameter"
    echo ""
    echo "$ ./createClusters.sh 5 2 us-central1-a acl-detroit-v2"
    exit 1
fi

if [ -z $2 ]
then
    echo "Please provide the number of nodes per cluster as second parameter"
    echo ""
    echo "$ ./createClusters.sh 5 2 us-central1-a acl-detroit-v2"
    exit 1
fi

if [ -z $3 ]
then
    echo "Please provide the zone as third parameter"
    echo ""
    echo "$ ./createClusters.sh 5 2 us-central1-a acl-detroit-v2"
    exit 1
fi

if [ -z $4 ]
then
    echo "Please provide the project name as fourth parameter"
    echo ""
    echo "$ ./createClusters.sh 5 2 us-central1-a acl-detroit-v2"
    exit 1
fi

numberofusers=$1
numberofnodes=$2
zone=$3
project=$4

i=1
while [ $i -le $numberofusers ]
do
	echo "creating cluster acllab$i"
    gcloud beta container --project $project clusters create acllab$i --zone $zone --username "admin" --cluster-version "1.12.10-gke.5" --machine-type "n1-standard-8" --image-type "UBUNTU" --disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes $numberofnodes --enable-cloud-logging --enable-cloud-monitoring --no-enable-ip-alias --addons HorizontalPodAutoscaling,HttpLoadBalancing --no-enable-autoupgrade --no-enable-autorepair
	i=$((i+1))
done
