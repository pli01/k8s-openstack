#!/bin/bash
#
source $(dirname $0)/scripts/utils.sh
#
# install openstack components
#
eval get_version keystone
helm upgrade --install $helm_args -n openstack --version $chart_version -f $release-values.yaml $release $chart_name
helm osh wait-for-pods openstack

eval get_version glance
helm upgrade --install $helm_args -n openstack --version $chart_version -f $release-ceph-values.yaml $release $chart_name
helm osh wait-for-pods openstack
#
eval get_version cinder
helm upgrade --install $helm_args -n openstack --version $chart_version -f $release-ceph-values.yaml $release $chart_name
helm osh wait-for-pods openstack

#eval get_version heat
#helm upgrade --install $helm_args -n openstack --version $chart_version -f $release-values.yaml $release $chart_name
#helm osh wait-for-pods openstack

#eval get_version designate
#helm upgrade --install $helm_args -n openstack --version $chart_version -f $release-values.yaml $release $chart_name
#helm osh wait-for-pods openstack
