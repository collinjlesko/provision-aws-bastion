#!/bin/bash

export KEPTN_IP=$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')

echo "Creating Virtual Service for Prometheus ..."

rm -f keptn/gen/prometheus-virtualservice.yaml

cat keptn/prometheus-virtualservice.yaml | \
  sed 's~YOUR_KEPTNIP_PLACEHOLDER~'"$KEPTN_IP"'~' >> keptn/gen/prometheus-virtualservice.yaml

kubectl create -f keptn/gen/prometheus-virtualservice.yaml

echo "Restarting Prometheus pod..."
kubectl delete pod -n monitoring -l app=prometheus-server

echo "You can reach keptn bridge on https://prometheus.keptn.$KEPTN_IP"
