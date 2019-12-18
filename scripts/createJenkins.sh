#!/bin/bash

# convenience script if you don't want to apply all yaml files manually

kubectl create -f ./manifests/k8s-namespace.yml
kubectl create -f ./manifests/k8s-storage.yml 

kubectl create -f ./manifests/k8s-docker-pvc-registry.yml
kubectl create -f ./manifests/k8s-docker-deployment.yml
kubectl create -f ./manifests/k8s-docker-service.yml

kubectl create -f ./manifests/k8s-jenkins-pvc-jobs.yml 
kubectl create -f ./manifests/k8s-jenkins-pvc-workspaces.yml 
kubectl create -f ./manifests/k8s-jenkins-deployment.yml
kubectl create -f ./manifests/k8s-jenkins-service.yml 
kubectl create -f ./manifests/k8s-jenkins-rbac.yml
