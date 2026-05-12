#!/bin/bash
#
# install openstack compute backend
#
PLACEMENT_VERSION=2026.1.4+a2a343968
helm upgrade --install $helm_args -n openstack --version $PLACEMENT_VERSION -f placement-values.yaml placement openstack-helm/placement
#helm osh wait-for-pods openstack

NOVA_VERSION=2026.1.8+a2a343968
helm upgrade --install $helm_args -n openstack --version $NOVA_VERSION -f nova-values.yaml nova openstack-helm/nova
#helm osh wait-for-pods openstack

NEUTRON_VERSION=2026.1.9+a2a343968
helm upgrade --install $helm_args -n openstack --version $NEUTRON_VERSION -f neutron-values.yaml neutron openstack-helm/neutron
helm osh wait-for-pods openstack
