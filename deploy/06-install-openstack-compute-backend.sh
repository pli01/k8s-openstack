#!/bin/bash
#
# install openstack compute backend
#
OPENVSWITCH_VERSION=2026.1.1+a2a343968
helm upgrade --install $helm_args -n openstack --version $OPENVSWITCH_VERSION -f openvswitch-values.yaml openvswitch openstack-helm/openvswitch
helm osh wait-for-pods openstack

LIBVIRT_VERSION=2026.1.4+a2a343968
helm upgrade --install $helm_args -n openstack --version $LIBVIRT_VERSION -f libvirt-values.yaml libvirt openstack-helm/libvirt
# Libvirt pods depend on Neutron OpenvSwitch - don't need wait-for-pods
#helm osh wait-for-pods openstack
