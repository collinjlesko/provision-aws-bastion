#!/bin/bash
nodeips=`kubectl get nodes --template '{{range .items}}{{.metadata.name}}{{" "}}{{end}}'`
i=1
myarr=($nodeips)

for arg in "${myarr[@]}"
        do
        echo "Node IP = $arg"
        echo "Currently running kube commands to sed daemon json in etc docker daemon json IP=$arg"
echo "apiVersion: v1
kind: Pod
metadata:
  name: privileged-pod
  namespace: default
spec:
  containers:
  - name: busybox
    image: busybox
    resources:
      limits:
        cpu: 200m
        memory: 100Mi
      requests:
        cpu: 100m
        memory: 50Mi
    command: [\"/bin/sh\", \"-c\"]
    args: [\"chroot /host sed -i 's/\\\\\\\"max-concurrent-downloads\\\\\\\": 10/\\\\\\\"max-concurrent-downloads\\\\\\\": 10,\\\\n  \\\\\\\"insecure-registries\\\\\\\": [\\\\\\\"0.0.0.0\\\\/0\\\\\\\"]/g' /etc/docker/daemon.json; chroot /host service docker restart\"]
    stdin: true
    securityContext:
      privileged: true
    volumeMounts:
    - name: host-root-volume
      mountPath: /host
  nodeName: $arg
  volumes:
  - name: host-root-volume
    hostPath:
      path: /
  hostNetwork: true
  hostPID: true
  restartPolicy: Never" > priv.yaml
	echo "Created priv yaml"
	kubectl create -f priv.yaml
	echo "Created pod on $arg"
	while [[ $(kubectl get pods privileged-pod -o 'jsonpath={..status.conditions[?(@.reason=="PodCompleted")]}') != "" ]]; do echo "waiting for pod" && sleep 1; done
	#kubectl exec -ti privileged-pod chroot /host cat /etc/docker/daemon.json
	#sleep 3
  echo "Sed Daemon & Restarted docker & exited pod"
	echo "Removing pod for $arg"
  sleep 2
	kubectl delete -f priv.yaml
	sleep 8
	i=$((i+1))
done
