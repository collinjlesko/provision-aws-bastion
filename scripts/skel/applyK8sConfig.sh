#!/bin/bash

echo "Creating Namespaces"
kubectl create -f manifests-env-zero/k8s-namespaces.yml

echo "Create SSD Storage for kubernetes cluster"
kubectl create -f manifests-env-zero/k8s-storage.yml