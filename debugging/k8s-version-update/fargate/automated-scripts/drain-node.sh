#!/bin/bash

export KUBERNETES_UPGRADE_VERSION=1.28
echo $KUBERNETES_UPGRADE_VERSION
#Add wait time before this script
sleep 60

#Wait for Kubernetes upgrade to complete
while [[ $(kubectl version | grep 'Server Version:' | grep -c ${KUBERNETES_UPGRADE_VERSION}) -lt 1 ]];
do
  echo "Kubernetes Server Version not yet upgraded to ${KUBERNETES_UPGRADE_VERSION}. Waiting..."
  sleep 30
done

#Get number of kubernetes nodes before the drain
START_NODE_COUNT=$(kubectl get nodes | tail -n +2 | awk '{print $1}' | wc -l)

#Cycle through the nodes and drain them until they are on the new version or 3 drains have been attempted.
LIMIT=0
while [ $(kubectl get nodes | tail -n +2 | grep -v ${KUBERNETES_UPGRADE_VERSION} | wc -l) -gt 0 ] || [ "${LIMIT}" -eq 3 ]
do
  #Drain the nodes
  for node in $(kubectl get nodes | tail -n +2 | grep -v ${KUBERNETES_UPGRADE_VERSION} | awk '{print $1}')
  do
    kubectl drain --ignore-daemonsets $node --delete-emptydir-data
  done

  #Wait for all the nodes to restart
  while [ $(kubectl get nodes | tail -n +2 | awk '{print $1}' | wc -l) -ne ${START_NODE_COUNT} ]
  do
    echo "Waiting for all nodes to restart..."
    sleep 60
  done

  #Wait for all nodes to be in ready state
  echo "Waiting for all nodes to be ready..."
  kubectl wait --for=condition=Ready nodes --all --timeout=900s

  ((LIMIT+=1))
done

#uncordon all nodes
for node in $(kubectl get nodes | tail -n +2 |  awk '{print $1}')
do
  kubectl uncordon $node
done
