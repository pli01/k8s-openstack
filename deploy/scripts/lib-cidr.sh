#!/usr/bin/env bash

# Premier Pod CIDR trouvé
podCIDR=$(
  kubectl get nodes \
    -o jsonpath='{.items[0].spec.podCIDR}'
)

# Première IP interne de nœud trouvée
nodeIP=$(
  kubectl get nodes \
    -o jsonpath='{.items[0].status.addresses[?(@.type=="InternalIP")].address}'
)

# Service CIDR (clusters kubeadm)
serviceCIDR=$(
  kubectl -n kube-system get cm kubeadm-config \
    -o jsonpath='{.data.ClusterConfiguration}' 2>/dev/null \
  | awk '/serviceSubnet:/ {print $2; exit}'
)

# Fallback si vide : lecture des arguments du kube-apiserver
if [ -z "$serviceCIDR" ]; then
  serviceCIDR=$(
    kubectl -n kube-system get pods \
      -l component=kube-apiserver \
      -o yaml 2>/dev/null \
    | sed -n 's/.*--service-cluster-ip-range=\([^", ]*\).*/\1/p' \
    | head -n1
  )
fi

printf 'podCIDR=%s\n' "$podCIDR"
printf 'serviceCIDR=%s\n' "$serviceCIDR"
printf 'nodeIP=%s\n' "$nodeIP"
