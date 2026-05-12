#!/bin/bash
helm repo add rook-release https://charts.rook.io/release
helm upgrade --install --create-namespace -n rook-ceph rook-ceph rook-release/rook-ceph -f rook-ceph-default-values.yaml
helm upgrade --install --create-namespace -n ceph rook-ceph-cluster rook-release/rook-ceph-cluster  -f rook-ceph-cluster-default-values.yaml
