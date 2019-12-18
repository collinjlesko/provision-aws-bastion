#!/bin/bash

echo "Creating PersistentVolumeClaim for Docker Registry to store Docker images ..."
kubectl create -f manifests-docker-registry/k8s-docker-registry-pvc.yml

echo "Creating Docker Registry Service ..."
kubectl create -f manifests-docker-registry/k8s-docker-registry-service.yml

echo "Creating Docker Registry Deployment ..."
kubectl create -f manifests-docker-registry/k8s-docker-registry-deployment.yml