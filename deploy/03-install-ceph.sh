#!/bin/bash
helm repo add rook-release https://charts.rook.io/release
helm_args="--create-namespace"
#helm_args="--wait --timeout 20m0s" # --wait-for-jobs"

ROOK_CEPH_VERSION=v1.19.7
helm upgrade --install $helm_args -n rook-ceph --version $ROOK_CEPH_VERSION -f rook-ceph-default-values.yaml rook-ceph rook-release/rook-ceph
helm osh wait-for-pods rook-ceph

helm upgrade --install $helm_args -n ceph --version $ROOK_CEPH_VERSION -f rook-ceph-cluster-default-values.yaml rook-ceph-cluster rook-release/rook-ceph-cluster
helm osh wait-for-pods ceph
