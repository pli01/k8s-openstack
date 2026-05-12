- no arm64 version: 
  - quay.io/airshipit/kubernetes-entrypoint
  - quay.io/airshipit/ceph-config-helper:latest-ubuntu-jammy

see 01-prereq.sh to build arm64 version

- pymysql python module unavailable between openstack-client:2026.1-ubuntu_noble-20260511
  and openstack-client:2026.1-ubuntu_noble-20260517
  https://opendev.org/openstack/python-openstackclient/commits/branch/master

force openstack-client:2026.1-ubuntu_noble-20260517 in all helm values

openvswitch module not available in minikube arm64 (need to rebuild boot2iso image)
