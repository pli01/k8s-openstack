#!/bin/bash

TARGETARCH=$(uname -m)

if [ "$TARGETARCH" == "arm64" ] ; then
  echo "# arm64"
  if ! type -p minikube  ; then
    curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-darwin-arm64
    chmod +x minikube-darwin-arm64
    sudo install minikube-darwin-arm64 /usr/local/bin/minikube
  fi
  brew list qemu || brew install qemu
  brew list socket_vmnet || brew install socket_vmnet
  HOMEBREW=$(which brew) && sudo ${HOMEBREW} services start socket_vmnet
fi
