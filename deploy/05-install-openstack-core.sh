#!/bin/bash
#
# install openstack components
#
KEYSTONE_VERSION=2026.1.5+a2a343968
helm upgrade --install $helm_args -n openstack --version $KEYSTONE_VERSION -f keystone-values.yaml keystone openstack-helm/keystone
helm osh wait-for-pods openstack

GLANCE_VERSION=2026.1.5+bad57716b
helm upgrade --install $helm_args -n openstack  --version $GLANCE_VERSION -f glance-ceph-values.yaml glance openstack-helm/glance
helm osh wait-for-pods openstack
#
CINDER_VERSION=2026.1.9+a2a343968
helm upgrade --install $helm_args -n openstack --version $CINDER_VERSION -f cinder-ceph-values.yaml cinder openstack-helm/cinder
helm osh wait-for-pods openstack

#HEAT_VERSION=2026.1.3+a2a343968
#helm upgrade --install $helm_args -n openstack --version $HEAT_VERSION -f heat-values.yaml heat openstack-helm/heat
#helm osh wait-for-pods openstack

#DESIGNATE_VERSION=2026.1.5+a2a343968
#helm upgrade --install $helm_args -n openstack --version $DESIGNATE_VERSION -f designate-values.yaml designate openstack-helm/designate
#helm osh wait-for-pods openstack
