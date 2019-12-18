#!/bin/bash

echo "Installing Istio - Gathering Facts"

export CLUSTER_ZONE=$(kubectl get nodes --show-labels | sed -n 's:.*zone=\(.*\),.*:\1:p' | awk 'FNR <= 1')
export CLUSTER_NAME=$(kubectl config current-context | sed -n "s:.*${CLUSTER_ZONE}_\(.*\):\1:p")
export CLUSTER_CIDR=$(gcloud container clusters describe ${CLUSTER_NAME} --zone=${CLUSTER_ZONE} | yq r - clusterIpv4Cidr)
export SERVICES_CIDR=$(gcloud container clusters describe ${CLUSTER_NAME} --zone=${CLUSTER_ZONE} | yq r - servicesIpv4Cidr)
export IP_RANGES="$CLUSTER_CIDR,$SERVICES_CIDR"
cat manifests-istio/auto/istio-demo.yaml | sed 's~PLACEHOLDER_CIDR~'"$IP_RANGES"'~' >> manifests-istio/istio-demo-gen.yaml

echo "Installing Istio - Creating Custom Resource Definitions..."
kubectl apply -f manifests-istio/crds.yaml

echo "Installing Istio - Deploy Istio Components"
kubectl apply -f manifests-istio/istio-demo-gen.yaml

echo "Istio Installed"

