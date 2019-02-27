#!/usr/bin/env bash

set -xeuo pipefail

test $# -eq 2
dist_location="$1"
presto_version="$2"

if test "${dist_location}" != ""; then
    echo "${dist_location}"
    exit
fi

dist_location="https://s3.us-east-2.amazonaws.com/starburstdata/presto"

if [[ "${presto_version}" = *"-t."* ]]; then
    dist_location="${dist_location}/teradata"
else
    dist_location="${dist_location}/starburst"
fi

version_dir="$(echo "${presto_version}" | sed -ne 's/^\([0-9]\+\)-\([a-z]\)\..*$/\1\2/p')"
test "${version_dir}" != "" # since we used `sed -n`, it will output anything only if there is a match
dist_location="${dist_location}/${version_dir}"

dist_location="${dist_location}/${presto_version}"
echo "${dist_location}"
