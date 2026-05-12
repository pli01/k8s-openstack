#!/bin/bash
#
# install prereq
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add openstack-helm https://tarballs.opendev.org/openstack/openstack-helm
helm repo update
#
# namespace
kubectl apply -f namespace.yaml
# storage class
kubectl apply -f storageclass-general.yaml
#
# install infra components
#
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx -n ingress-nginx  -f ingress-nginx-values.yaml
# ingress-openstack
kubectl apply -f ingressclass-openstack.yaml
#
# ceph-adapter-rook
#
helm upgrade --install ceph-adapter-rook openstack-helm/ceph-adapter-rook -n openstack -f ceph-adapter-rook-values.yaml
#
# core services
#
helm upgrade --install rabbitmq  openstack-helm/rabbitmq  -n openstack --timeout=600s -f rabbitmq-values.yaml
helm upgrade --install mariadb   openstack-helm/mariadb   -n openstack -f mariadb-values.yaml
helm upgrade --install memcached openstack-helm/memcached -n openstack -f memcached-values.yaml
#
# install openstack components
#
helm upgrade --install keystone openstack-helm/keystone -n openstack -f keystone-values.yaml
helm upgrade --install glance   openstack-helm/glance   -n openstack -f glance-ceph-values.yaml
helm upgrade --install cinder   openstack-helm/cinder   -n openstack -f cinder-ceph-values.yaml
helm upgrade --install heat     openstack-helm/heat     -n openstack -f heat-values.yaml
helm upgrade --install horizon  openstack-helm/horizon  -n openstack -f horizon-values.yaml
#
#
# expose public endpoint keystone.127.0.0.1.nip.io:8080, horizon.127.0.0.1.nip.io:8080
kubectl apply -f external-ingress.yaml -n openstack
