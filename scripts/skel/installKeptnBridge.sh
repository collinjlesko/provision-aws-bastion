#!/bin/bash

export KEPTN_IP=$(kubectl get cm keptn-domain -n keptn -o=jsonpath='{.data.app_domain}')

echo "Creating Virtual Service for keptn bridge ..."

rm -f keptn/gen/keptn-bridge-virtualservice.yaml

cat keptn/keptn-bridge-virtualservice.yaml | \
  sed 's~YOUR_KEPTNIP_PLACEHOLDER~'"$KEPTN_IP"'~' >> keptn/gen/keptn-bridge-virtualservice.yaml

kubectl create -f keptn/gen/keptn-bridge-virtualservice.yaml

echo "Restarting keptn bridge pod..."
kubectl delete pod -n keptn -l run=bridge

echo "You can reach keptn bridge on https://bridge.keptn.$KEPTN_IP"
