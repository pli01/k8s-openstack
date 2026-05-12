#!/bin/bash
#
# install openstack horizon
#
HORIZON_VERSION=2026.1.3+a2a343968
helm upgrade --install $helm_args -n openstack --version $HORIZON_VERSION -f horizon-values.yaml horizon openstack-helm/horizon
helm osh wait-for-pods openstack
#
# expose public endpoint keystone.127.0.0.1.nip.io:8080, horizon.127.0.0.1.nip.io:8080
#
kubectl apply -f external-ingress.yaml -n openstack
