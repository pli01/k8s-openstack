#!/bin/bash
#
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
INGRESS_NGINX_VERSION=4.15.1
helm upgrade --install $helm_args -n ingress-nginx --version $INGRESS_NGINX_VERSION  -f ingress-nginx-values.yaml ingress-nginx ingress-nginx/ingress-nginx
helm osh wait-for-pods ingress-nginx
# ingress-openstack
kubectl apply -f ingressclass-openstack.yaml
#
# ceph-adapter-rook
#
CEPH_ADAPTER_ROOK_VERSION=2026.1.3+a2a343968
helm upgrade --install $helm_args -n openstack --version $CEPH_ADAPTER_ROOK_VERSION -f ceph-adapter-rook-values.yaml ceph-adapter-rook openstack-helm/ceph-adapter-rook
helm osh wait-for-pods openstack
#
# core services
#
RABBITMQ_VERSION=2026.1.1+a2a343968
helm upgrade --install $helm_args -n openstack --version $RABBITMQ_VERSION -f rabbitmq-values.yaml rabbitmq  openstack-helm/rabbitmq
helm osh wait-for-pods openstack

MARIADB_VERSION=2026.1.3+a2a343968
helm upgrade --install $helm_args -n openstack --version $MARIADB_VERSION -f mariadb-values.yaml mariadb openstack-helm/mariadb
helm osh wait-for-pods openstack

MEMCACHED_VERSION=2026.1.0+a2a343968
helm upgrade --install $helm_args -n openstack --version $MEMCACHED_VERSION -f memcached-values.yaml memcached openstack-helm/memcached
helm osh wait-for-pods openstack
#
# bind9 (designate)
#helm upgrade --install $helm_args -n dns-system --create-namespace -f bind9-values.yaml bind9 openstack-helm-stack/custom-charts/charts/bind9
