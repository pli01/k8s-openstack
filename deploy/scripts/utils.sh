#!/bin/bash

#
# get release chart_name chart_version from versions.txt
#
function get_version() {
  [ -z "$1" ] || eval $(grep "^$1 " versions.txt |awk ' { print "release="$1,";chart_name="$2,";chart_version="$3,";" }')
}
