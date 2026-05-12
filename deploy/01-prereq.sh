#!/bin/bash
#
# Fix for MacM1:
# build kubernetes-entrypoint docker image for arm64
# build ceph-config-helper docker image for arm64
# then load image in kind/minikube cluster
#
(
git clone https://github.com/airshipit/kubernetes-entrypoint
(
cd kubernetes-entrypoint
export TARGETARCH=arm64 ; make images TARGETARCH=arm64
)
)

(
git clone https://github.com/openstack/openstack-helm-images
cd openstack-helm-images
perl -pi -e 's/kubernetes-client-linux-amd64/kubernetes-client-linux-arm64/' ceph-config-helper/Dockerfile.ubuntu
docker build -f ceph-config-helper/Dockerfile.ubuntu --build-arg FROM=quay.io/airshipit/ubuntu:jammy --build-arg CEPH_REPO='http://download.ceph.com/debian-tentacle' --build-arg CEPH_RELEASE='tentacle' --build-arg CEPH_RELEASE_TAG='20.2.1-1jammy' --build-arg CEPH_KEY='http://download.ceph.com/keys/release.asc' -t quay.io/airshipit/ceph-config-helper:ubuntu_jammy_20.2.1-1-20260407 ceph-config-helper
)

