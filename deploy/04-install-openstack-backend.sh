#!/bin/bash
#
source $(dirname $0)/scripts/utils.sh

# install prereq
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add openstack-helm https://tarballs.opendev.org/openstack/openstack-helm
helm repo update
helm_args="--wait --timeout 20m0s" #  --wait-for-jobs"
#
# namespace
kubectl apply -f namespace.yaml
# storage class
#kubectl apply -f storageclass-general.yaml
#
# install infra components
#
eval get_version ingress-nginx
helm upgrade --install $helm_args -n ingress-nginx --version $chart_version  -f $release-values.yaml $release $chart_name
helm osh wait-for-pods ingress-nginx
# ingress-openstack
kubectl apply -f ingressclass-openstack.yaml
#
# ceph-adapter-rook
#
eval get_version ceph-adapter-rook
helm upgrade --install $helm_args -n openstack --version $chart_version -f $release-values.yaml $release $chart_name
helm osh wait-for-pods openstack
#
# core services
#
eval get_version rabbitmq
helm upgrade --install $helm_args -n openstack --version $chart_version -f $release-values.yaml $release $chart_name
helm osh wait-for-pods openstack

eval get_version mariadb
helm upgrade --install $helm_args -n openstack --version $chart_version -f $release-values.yaml $release $chart_name
helm osh wait-for-pods openstack

eval get_version memcached
helm upgrade --install $helm_args -n openstack --version $chart_version -f $release-values.yaml $release $chart_name
helm osh wait-for-pods openstack
#
# bind9 (designate)
#helm upgrade --install $helm_args -n dns-system --create-namespace -f bind9-values.yaml $release $chart_name

