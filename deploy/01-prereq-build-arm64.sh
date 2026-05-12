#!/bin/bash
#
# Fix for MacM1:
# build kubernetes-entrypoint docker image for arm64
# build ceph-config-helper docker image for arm64
# then load image in kind/minikube cluster
#
(
  git clone https://github.com/airshipit/kubernetes-entrypoint
  cd kubernetes-entrypoint
  export TARGETARCH=arm64 ; make images TARGETARCH=arm64
)

#
# ceph-config-helper
#
(
  git clone https://github.com/openstack/openstack-helm-images
  cd openstack-helm-images
  perl -pi -e 's/kubernetes-client-linux-amd64/kubernetes-client-linux-arm64/' ceph-config-helper/Dockerfile.ubuntu
  docker build -f ceph-config-helper/Dockerfile.ubuntu --build-arg FROM=quay.io/airshipit/ubuntu:jammy --build-arg CEPH_REPO='http://download.ceph.com/debian-tentacle' --build-arg CEPH_RELEASE='tentacle' --build-arg CEPH_RELEASE_TAG='20.2.1-1jammy' --build-arg CEPH_KEY='http://download.ceph.com/keys/release.asc' -t quay.io/airshipit/ceph-config-helper:ubuntu_jammy_20.2.1-1-20260407 ceph-config-helper
)

#
# horizon custom image: add components (heat, designate, ...)
#
#```
#diff --git a/horizon/Dockerfile b/horizon/Dockerfile
#index cde0ebe..299df4b 100644
#--- a/horizon/Dockerfile
#+++ b/horizon/Dockerfile
#@@ -22,6 +22,7 @@ RUN if [ -s /etc/image_info/bindep_build.txt ]; then \
#         && rm -rf /var/lib/apt/lists/*; \
#     fi
#
#+RUN for d in heat-dashboard designate-dashboard ; do echo "$d" >> /etc/image_info/python_packages.txt; done
# RUN sed -i '/^horizon===/d' /upper-constraints.txt \
#     && git clone --filter=blob:none -b ${HORIZON_REF} ${HORIZON_REPO} /tmp/horizon \
#     && uv pip install \
#```
#
#docker build -f horizon/Dockerfile \
# --build-arg BASE_VENV_BUILDER=quay.io/airshipit/venv_builder:2026.1-ubuntu_noble \
# --build-arg BASE_RUNTIME=quay.io/airshipit/base:2026.1-ubuntu_noble \
# --build-arg HORIZON_REF=stable/2026.1 \
# -t quay.io/airshipit/horizon-heat:2026.1-ubuntu_noble-20260530 \
#  .

