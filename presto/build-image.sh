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
-r, --rpm; Set presto server RPM file location
-c, --cli; Set presto CLI executable jar location
-v, --version; Set presto version
-i, --incremental; Allow incremetal build
" | column -t -s ";"
}

INCREMETAL=false

options=$(getopt -o r:c:v:i --long rpm:,cli:,version:,incremental -n 'parse-options' -- "$@")

if [ $? != 0 ]; then
  echo "Failed parsing options." >&2
  exit 1
fi

while true; do
  case "$1" in
    -r | --rpm ) PRESTO_RPM=$2; shift 2 ;;
    -c | --cli ) PRESTO_CLI=$2; shift 2 ;;
    -v | --version ) PRESTO_VERSION=$2; shift 2;;
    -i | --incremental) INCREMETAL=true; shift ;;
    -- ) shift; break ;;
    "" ) break ;;
    * ) echo "Unknown option provided ${1}"; usage; exit 1; ;;
  esac
done

if [ -z "${PRESTO_RPM}" ]; then
  echo "-r/--rpm option is missing"
  usage
  exit 1
fi

if [ -z "${PRESTO_CLI}" ]; then
  echo "-c/--cli option is missing"
  usage
  exit 1
fi

if [ -z "${PRESTO_VERSION}" ]; then
  echo "-v/--version option is missing"
  usage
  exit 1
fi

set -xeuo pipefail

PRESTO_RPM_BASENAME=$(basename $PRESTO_RPM)
PRESTO_CLI_BASENAME=$(basename $PRESTO_CLI)

function cleanup {
  rm -f "installdir/${PRESTO_RPM_BASENAME}"
  rm -f "installdir/${PRESTO_CLI_BASENAME}"
}
trap cleanup EXIT

cp "${PRESTO_RPM}" installdir
cp "${PRESTO_CLI}" installdir

IMAGE_NAME=starburstdata/presto:${PRESTO_VERSION}

if [ "${INCREMETAL}" = true ] && [[ $(docker image list -q ${IMAGE_NAME}) ]]; then
  echo "Running incremetal build..."
  docker build . \
    --build-arg "presto_version=${PRESTO_VERSION}" \
    --build-arg "BASE_IMAGE=${IMAGE_NAME}" \
    --build-arg dist_location=/installdir \
    -t "${IMAGE_NAME}" \
    -f incremental.Dockerfile \
    --squash --rm
else
  docker build . \
    --build-arg "presto_version=${PRESTO_VERSION}" \
    --build-arg dist_location=/installdir \
    -t "${IMAGE_NAME}" \
    --squash --rm
fi
