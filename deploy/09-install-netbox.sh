#!/bin/bash
helm repo add netbox https://charts.netbox.oss.netboxlabs.com/
helm repo update
helm_args="--create-namespace"
NETBOX_VERSION=8.3.18
helm upgrade --install $helm_args -n netbox --version $NETBOX_VERSION -f netbox-default-values.yaml netbox netbox/netbox
