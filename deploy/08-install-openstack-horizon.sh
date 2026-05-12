#!/bin/bash
#
#
source $(dirname $0)/scripts/utils.sh
#
# install openstack horizon
#
eval get_version horizon
helm upgrade --install $helm_args -n openstack --version $chart_version -f $release-values.yaml $release $chart_name
helm osh wait-for-pods openstack
#
# expose public endpoint keystone.127.0.0.1.nip.io:8080, horizon.127.0.0.1.nip.io:8080
#
kubectl apply -f external-ingress.yaml -n openstack
