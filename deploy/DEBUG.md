# Fixes for ARM64 version

- install socket_vmnet
- allow traffic on bridge

```
brew install socket_vmnet
HOMEBREW=$(which brew) && sudo ${HOMEBREW} services restart socket_vmnet

sudo vi /etc/pf.anchors/minikube

Add:
pass from bridge100 to any keep state
pass from any to bridge100 keep state
pass on vmnet0

sudo vi /etc/pf.conf

Add:

anchor "minikube"
load anchor "minikube" from "/etc/pf.anchors/minikube"

sudo pfctl -f /etc/pf.conf
sudo pfctl -e
```

## images for arm64
No image available for arm64 architecture for the following components:
- no arm64 version:
  - quay.io/airshipit/kubernetes-entrypoint
  - quay.io/airshipit/ceph-config-helper:latest-ubuntu-jammy

see 01-prereq.sh to build arm64 version

## openstack-client
- pymysql python module unavailable between openstack-client:2026.1-ubuntu_noble-20260511
  and openstack-client:2026.1-ubuntu_noble-20260517
  Fixed in openstack-client:2026.1-ubuntu_noble
  https://opendev.org/openstack/python-openstackclient/commits/branch/master

force openstack-client:2026.1-ubuntu_noble-20260609 in all helm values

##  openvswitch module not available in minikube arm64
- openvswitch module not available in minikube arm64 (need to rebuild boot2iso image)
- patch merged in minikube arm64 iso (https://github.com/kubernetes/minikube/commit/fa70c213bdc2df18a183f8a6a46521d1aa8decee)
- Fix: disable gre
```
kubectl edit -n openstack configmap/openvswitch-bin

openvswitch-vswitchd-init-modules.sh:
     chroot /mnt/host-rootfs modprobe openvswitch
     chroot /mnt/host-rootfs modprobe gre || true
     chroot /mnt/host-rootfs modprobe vxlan || true

kubectl rollout restart -n openstack daemonset.apps/openvswitch
```

##  libvirt daemonset error with cgroup
```
kubectl edit -n openstack configmap/libvirt-libvirt-default-bin
kubectl edit -n openstack configmap/libvirt-bin

# Replace
cgexec -g cpu,hugetlb,memory,pids:/osh-libvirt \
  systemd-run --scope --slice=system \

systemd-run --scope --slice=system libvirtd --listen &

# and last with
systemd-run --scope --slice=system libvirtd --listen

kubectl rollout restart -n openstack daemonset.apps/libvirt-libvirt-default

```

## libvirt arm64 missing qemu-efi-aarch64
```
# in libvirt pod
apt-get install -y qemu-efi-aarch64
```

## use designate with backend-bind9
- Get controller IP, pod cidr, svc cidr with `utils.sh`
```
CONTROLLER_SERVER_IP=( source utils.sh 2>&1 >- ; echo $nodeIP)
```
- generate bind rndc secret key:
```
docker run --rm -it   ubuntu/bind9:9.20-26.04_edge exec rndc-confgen
# get rndc secret
RNDC_SECRET_KEY=$(docker run --rm -it   ubuntu/bind9:9.20-26.04_edge exec rndc-confgen|grep -v "#" |grep "secret" |sed -e 's/\t//g; s/secret "//g; s/".*//g')
```
- replace RNDC_SECRET_KEY in bind9-values.yaml and bind9-secret.yaml
- replace CONTROLLER_SERVER_IP in bind9-values.yaml
- install bind9:
  helm upgrade --install $helm_args -n dns-system  bind9 custom-charts/charts/bind9 --create-namespace -f bind9-values.yaml
  Get bind9 cluster-ip: kubectl get svc -n dns-system bind9

- designate-worker: need to add rndc.key as secret
  add bind9-secrets:
```
  kubectl apply -f bind9-secret.yaml -n openstack
```
- designate: fix designate-values.yaml
    add bind9 cluster-ip in nameservers

- to use designate with backend-bind9: need rndc in designate-worker image
  Patch is now merged: https://opendev.org/openstack/openstack-helm-images/commit/b04668ae06e4c52ac78a3047db82e6f07d60b6df

- add secret volume/volumeMounts in designate-worker
  kubectl edit  -n openstack deploy designate-worker
```
     name: designate-worker
     volumeMounts:
        - mountPath: /etc/designate/rndc.key
          name: designate-rndc-key
          readOnly: true
          subPath: rndc.key

      volumes:
      - name: designate-rndc-key
        secret:
          defaultMode: 420
          secretName: designate-rndc-key
```
