#!/bin/bash

# create small cluster (1 CP, 1 WK) with 8080 and 8443 exposed
#   add labels on nodes
kind get clusters | grep "osh" || kind create cluster -n osh --config kind-config.yaml

# fix for MacM1 : load local quay.io/airshipit/kubernetes-entrypoint
kind load docker-image quay.io/airshipit/kubernetes-entrypoint:latest-ubuntu_noble -n osh
kind load docker-image quay.io/airshipit/ceph-config-helper:ubuntu_jammy_20.2.1-1-20260407 -n osh
