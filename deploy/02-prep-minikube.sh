#!/bin/bash

TARGETARCH=$(uname -m)

if [ "$TARGETARCH" == "arm64" ] ; then
  echo "# arm64"
  HOMEBREW=$(which brew) && sudo ${HOMEBREW} services start socket_vmnet
fi

minikube delete
minikube start \
  --nodes=1 \
  --disk-size=80g \
  --cpus=6 \
  --memory=8192 \
  --driver=qemu2 \
  --network socket_vmnet \
  --extra-disks=1 \
  --kubernetes-version=v1.34.3

# reduce MTU
minikube ssh -- sudo ip link set dev eth0 mtu 1400

#minikube addons enable ingress
minikube addons enable metrics-server
#minikube addons enable storage-provisioner
#minikube addons enable storage-provisioner-rancher

kubectl label --overwrite nodes --all openstack-compute-node=enabled
kubectl label --overwrite nodes --all openstack-control-plane=enabled
kubectl label --overwrite nodes --all openvswitch=enabled
kubectl label --overwrite nodes --all ingress-ready="true"

# docker must be running
minikube image  load quay.io/airshipit/kubernetes-entrypoint:latest-ubuntu_noble
minikube image  load quay.io/airshipit/ceph-config-helper:ubuntu_jammy_20.2.1-1-20260407
