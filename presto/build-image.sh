#!/bin/bash

# Gets the command name without path
function cmd()
{
  basename $0
}

function usage()
{
  echo "\
`cmd` [OPTIONS...]
-v, --version; Version with which to tag the resulting image; usually the same as the Presto version
-a, --archive; Local path to Presto server tar.gz archive
-c, --cli; Local path to Presto CLI executable jar
-i, --incremental; Allow incremetal build
" | column -t -s ";"
}

INCREMETAL=false

options=$(getopt -o v:a:ic: --long version:,archive:,incremental,cli: -n 'parse-options' -- "$@")

if [ $? != 0 ]; then
  echo "Failed parsing options." >&2
  exit 1
fi

while true; do
  case "$1" in
    -v | --version ) VERSION=$2; shift 2;;
    -a | --archive ) PRESTO_ARCHIVE=$2; shift 2;;
    -i | --incremental) INCREMETAL=true; shift ;;
    -c | --cli) PRESTO_CLI=$2; shift 2 ;;
    -- ) shift; break ;;
    "" ) break ;;
    * ) echo "Unknown option provided ${1}"; usage; exit 1; ;;
  esac
done

if [ -z "${VERSION}" ]; then
  echo "-a/--archive option is missing"
  usage
  exit 1
fi

if [ -z "${PRESTO_ARCHIVE}" ]; then
  echo "-a/--archive option is missing"
  usage
  exit 1
fi

if [ -z "${PRESTO_CLI}" ]; then
  echo "-c/--cli option is missing"
  usage
  exit 1
fi

set -xeuo pipefail

IMAGE_NAME=starburstdata/presto:${VERSION}

if [ "${INCREMETAL}" = true ] && [[ $(docker image list -q ${IMAGE_NAME}) ]]; then
  echo "Running incremetal build..."
  docker build . \
    --build-arg "presto_archive=${PRESTO_ARCHIVE}" \
    --build-arg "presto_cli=${PRESTO_CLI}" \
    --build-arg "BASE_IMAGE=${IMAGE_NAME}" \
    -t "${IMAGE_NAME}" \
    -f incremental.Dockerfile \
    --squash --rm
else
  docker build . \
    --build-arg "presto_archive=${PRESTO_ARCHIVE}" \
    --build-arg "presto_cli=${PRESTO_CLI}" \
    -t "${IMAGE_NAME}" \
    --squash --rm
fi
