#!/bin/bash
#
# check binaries
# minikube
# docker
# helm
# helm plugins list:
# diff    	3.9.4  	Preview helm upgrade changes as a diff
# helm-git	1.3.0  	Get non-packaged Charts directly from Git.
# s3      	0.14.0 	Provides AWS S3 protocol support for charts and repos. https://github.com/hypnoglow/helm-s3
# secrets 	4.6.5  	This plugin provides secrets values encryption for Helm charts secure storing
# osh     	0.1.0  	openstack-helm plugin for helm

# kubectl
# arm64: socket_vmnet
#

# provide helm openstack helm plugin: helm osh wait-for-pods
helm plugin install https://opendev.org/openstack/openstack-helm-plugin
