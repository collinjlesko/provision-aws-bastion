#!/bin/sh

if [ -z $1 ]
then
    echo "Please provide the number of clusters as first parameter"
    echo ""
    echo "$ ./deleteClusters.sh 5"
    exit 1
fi

if [ -z $2 ]
then
    echo "Please provide the zone as second parameter"
    echo ""
    echo "$ ./deleteClusters.sh 5 us-central1-a"
    exit 1
fi

numberofusers=$1
zone=$2


i=1
while [ $i -le $numberofusers ]
do
	echo "delete cluster acllab$i"
	gcloud container clusters delete acllab$i --zone $zone
	i=$((i+1))
done