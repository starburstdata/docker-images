#/usr/bin/env bash

set -x
set -e
set -o pipefail

TARGET_TAG=latest
ROOT_PATH="$(dirname $0)"

image() {
  local dir=$1
  local image_name=$2
  local image_tag=$3

  build_image $dir $image_name $image_tag
  push_image $image_name $image_tag
}

build_image() {
  local dir=$1
  local image_name=$2
  local image_tag=$3

  docker build $ROOT_PATH/$dir -t ${image_name}:${image_tag}
}

push_image() {
  local image_name=$1
  local image_tag=$2

  echo "Pushing image ${image_name}:{$image_tag}"
  docker push ${image_name}:${image_tag}
}

image centos6-presto-admin-tests-runtime starburstdata/centos6-presto-admin-tests-runtime ${TARGET_TAG}
image centos6-presto-admin-tests-build starburstdata/centos6-presto-admin-tests-build ${TARGET_TAG}
