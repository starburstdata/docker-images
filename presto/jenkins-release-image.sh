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

  This utility is used to build and push the starburstdata Presto and UBI
  images.

-v, --version      Presto version to use; required.
-d, --dry-run      Flag preventing the newly built Docker image from being pushed
                   to the Docker registry. This flag acts on both
                   the Presto image and UBI. By default newly built images are
                   pushed.

-l, --latest       Flag indicating if the Presto image should be pushed to the
                   latest tag. Defaults to false.

-u, --ubi          Flag indiciating if the Universal Base Image of Presto should
                   be built. Defaults to false.
"
}

PUSH=true
LATEST=false
UBI=false

options=$(getopt -o v:dlu --long version:,dry-run,latest,ubi -n 'parse-options' -- "$@")

if [ $? != 0 ]; then
  echo "Failed parsing options." >&2
  exit 1
fi

while true; do
  case "$1" in
    -v | --version ) PRESTO_VERSION=$2; shift 2;;
    -d | --dry-run) PUSH=false; shift ;;
    -l | --latest) LATEST=true; shift ;;
    -u | --ubi) UBI=true; shift ;;
    -- ) shift; break ;;
    "" ) break ;;
    * ) echo "Unknown option provided ${1}"; usage; exit 1; ;;
  esac
done

set -xeuo pipefail

if [ -z "${PRESTO_VERSION}" ]; then
  echo "-v/--version option is missing"
  usage
  exit 1
fi

PRESTO_ARCHIVE="presto-server-${PRESTO_VERSION}.tar.gz"
PRESTO_CLI="presto-cli-${PRESTO_VERSION}-executable.jar"

DIST_LOCATION="$(installdir/find-dist-location.sh "" "${PRESTO_VERSION}")"

if [ ! -f "${PRESTO_ARCHIVE}" ]; then
  curl -fsSL "${DIST_LOCATION}/${PRESTO_ARCHIVE}" -o ${PRESTO_ARCHIVE}
fi

if [ ! -f "${PRESTO_CLI}" ]; then
  curl -fsSL "${DIST_LOCATION}/${PRESTO_CLI}" -o ${PRESTO_CLI}
fi

if [ "$PUSH" = true ] ; then
  docker login --username $JENKINS_USERNAME --password $JENKINS_PASSWORD
fi

./build-image.sh --version $PRESTO_VERSION --archive ${PRESTO_ARCHIVE} --cli ${PRESTO_CLI}

if [ "$PUSH" = true ] ; then
  docker push starburstdata/presto:$PRESTO_VERSION
fi

if [ "$LATEST" = true ] ; then
  docker tag starburstdata/presto:$PRESTO_VERSION starburstdata/presto:latest

  if [ "$PUSH" = true ] ; then
    docker push starburstdata/presto:latest
  fi
fi

if [ "$UBI" = true ] ; then
  virtualenv -p python3 .venv
  source .venv/bin/activate
  pip3 install awscli --upgrade
  aws ecr get-login --no-include-email --region us-east-2 | bash
  DOCKER_REGISTRY="200442618260.dkr.ecr.us-east-2.amazonaws.com/k8s"
  docker build . -t $DOCKER_REGISTRY/starburstdata/presto:${TAG}-ubi8.1 --build-arg base_image="$DOCKER_REGISTRY/starburstdata/ubi8-python2:1"
  docker push $DOCKER_REGISTRY/starburstdata/presto:${TAG}-ubi8.1
fi
