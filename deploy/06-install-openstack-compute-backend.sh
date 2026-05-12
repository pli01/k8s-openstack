#!/bin/bash
#
#
source $(dirname $0)/scripts/utils.sh
#
# install openstack compute backend
#
eval get_version openvswitch
helm upgrade --install $helm_args -n openstack --version $chart_version -f $release-values.yaml $release $chart_name
helm osh wait-for-pods openstack

eval get_version libvirt
helm upgrade --install $helm_args -n openstack --version $chart_version -f $release-values.yaml $release $chart_name
# Libvirt pods depend on Neutron OpenvSwitch - don't need wait-for-pods
#helm osh wait-for-pods openstack
