# Deploy openstack-helm on kubernetes (lab)

- setup/challenge: for continuous integration testing and mini-labs
  - using minikube/qemu
  - Mac M1 (arm64)

Based on:
- OpenStack-Helm project: https://docs.openstack.org/openstack-helm/latest/readme.html#mission
- Rook Ceph
- Deploy on kubernetes cluster

Enable following components:
- common
  - ingress-nginx
  - rook ceph
  - rook ceph cluster (provide block device)
- openstack backend
  - rabbitmq
  - mariadb
  - memcached
  - bind9 (optional if used with designage)
- openstack core
  - keystone
  - glance
  - cinder
  - heat
  - designate (with bind9 backend)
- openstack compute backend
  - openvswitch
  - libvirt
- openstack compute
  - placement
  - nova
  - neutron
- openstack frontend
  - horizon (with custom heat and designate dashboard)

- extra
  - netbox
