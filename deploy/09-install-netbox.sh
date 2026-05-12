#!/bin/bash
#
#
source $(dirname $0)/scripts/utils.sh
#
#
helm repo add netbox https://charts.netbox.oss.netboxlabs.com/
helm repo update
helm_args="--create-namespace"

eval get_version netbox
helm upgrade --install $helm_args -n netbox --version $chart_version -f $release-default-values.yaml $release $chart_name

