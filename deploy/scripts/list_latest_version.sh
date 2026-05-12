#!/bin/bash

helm repo  update 2>&- >&-

grep upgrade 0*.sh | \
  grep -v '#' | \
  awk ' {print $NF}' | \
  while read i ; do \
    chart_version=$(helm search repo $i --versions -o json|jq -re '.[0].name + " " + .[0].version') ;
    name=$(echo "${chart_version}" |awk ' { print $1 }'|awk -F/ '{ print $2}') ;
    echo "$name $chart_version"
  done
