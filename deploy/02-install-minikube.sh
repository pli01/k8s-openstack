#!/bin/bash

MINIKUBE_BIN=${MINIKUBE_BIN:-minikube}
KUBERNETES_VERSION=v1.34.8

$MINIKUBE_BIN delete
$MINIKUBE_BIN start \
  --nodes=1 \
  --disk-size=80g \
  --cpus=4 \
  --memory=12288 \
  --driver=qemu2 \
  --network socket_vmnet \
  --extra-disks=1 \
  --kubernetes-version=$KUBERNETES_VERSION
  # --cni=flannel

helm osh wait-for-pods kube-system
#
# reduce MTU
$MINIKUBE_BIN ssh -- sudo ip link set dev eth0 mtu 1400

#$MINIKUBE_BIN addons enable ingress
$MINIKUBE_BIN addons enable metrics-server
# A sample (non-production) CSI Driver that creates a local directory as a volume on a single node
#$MINIKUBE_BIN addons enable csi-hostpath-driver
#$MINIKUBE_BIN addons enable storage-provisioner
#$MINIKUBE_BIN addons enable storage-provisioner-rancher

helm osh wait-for-pods kube-system

# Load custom arm64 image
# docker must be running
$MINIKUBE_BIN image load quay.io/airshipit/kubernetes-entrypoint:latest-ubuntu_noble
$MINIKUBE_BIN image load quay.io/airshipit/ceph-config-helper:ubuntu_jammy_20.2.1-1-20260407
$MINIKUBE_BIN image load quay.io/airshipit/horizon-heat:2026.1-ubuntu_noble-20260530

# Label
kubectl label --overwrite nodes --all openstack-compute-node=enabled
kubectl label --overwrite nodes --all openstack-control-plane=enabled
kubectl label --overwrite nodes --all openvswitch=enabled
kubectl label --overwrite nodes --all ingress-ready="true"
