#!/bin/bash

# test ceph cluster
kubectl exec -n ceph deploy/rook-ceph-tools -- ceph status
kubectl exec -n ceph deploy/rook-ceph-tools -- ceph osd pool ls
kubectl exec -n ceph deploy/rook-ceph-tools -- ceph mgr module ls

# with minikube, forward external port 8080 to 80
kubectl port-forward -n ingress-nginx   svc/ingress-nginx-controller  8080:80

#test outside cluster: all ports run on 8080

curl http://keystone.127.0.0.1.nip.io:8080/
curl http://keystone.127.0.0.1.nip.io:8080/v3
curl http://horizon.127.0.0.1.nip.io:8080/auth/login/
curl http://glance.127.0.0.1.nip.io:8080/
curl http://cinder.127.0.0.1.nip.io:8080/
curl http://heat.127.0.0.1.nip.io:8080/
#
# get admin password
OS_PASSWORD="$(kubectl get secret keystone-keystone-admin   -n openstack   -o jsonpath="{.data.OS_PASSWORD}" | base64 -d)"

# run inside cluster
kubectl run -it test --rm   -n openstack   --image=quay.io/airshipit/openstack-client:2026.1-ubuntu_noble-20260517 -- bash

# run inside pod

export OS_AUTH_URL=http://keystone-api.openstack.svc.cluster.local:5000/v3
export OS_USERNAME=admin
export OS_PASSWORD=$OS_PASSWORD
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_IDENTITY_API_VERSION=3
export OS_PASSWORD=password
# use internal endpoint in pod
export OS_INTERFACE=internal
openstack token issue
openstack catalog list
openstack user list
openstack project list


