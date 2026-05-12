#!/bin/bash
source $(dirname $0)/scripts/utils.sh

helm repo add rook-release https://charts.rook.io/release
helm_args="--create-namespace"
#helm_args="--wait --timeout 20m0s" # --wait-for-jobs"

eval get_version rook-ceph
helm upgrade --install $helm_args -n rook-ceph --version $chart_version -f $release-default-values.yaml $release $chart_name
helm osh wait-for-pods rook-ceph

eval get_version rook-ceph-cluster
helm upgrade --install $helm_args -n ceph --version $chart_version -f $release-default-values.yaml $release $chart_name
helm osh wait-for-pods ceph
