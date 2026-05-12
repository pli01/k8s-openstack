#!/bin/bash
#
#
source $(dirname $0)/scripts/utils.sh
#
# install openstack compute backend
#
eval get_version placement
helm upgrade --install $helm_args -n openstack --version $chart_version -f $release-values.yaml $release $chart_name
#helm osh wait-for-pods openstack

eval get_version nova
helm upgrade --install $helm_args -n openstack --version $chart_version -f $release-values.yaml $release $chart_name
#helm osh wait-for-pods openstack

eval get_version neutron
helm upgrade --install $helm_args -n openstack --version $chart_version -f $release-values.yaml $release $chart_name
helm osh wait-for-pods openstack
