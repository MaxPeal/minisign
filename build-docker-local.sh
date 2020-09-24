#!/bin/env bash

echo build docker local and push to CR

#TAG="maxpeal/minisign:v0.9"
TAG="maxpeal/minisign:foo"

export progressFlag="--progress=plain"

#docker buildx inspect --bootstrap | grep -i Platforms | cut -d":" -f2 | tr -d "[:space:]"

# DOCKER_BUILDKIT=1 docker buildx build $progressFlag --platform $(docker buildx inspect --bootstrap | grep -i Platforms | cut -d":" -f2 | tr -d "[:space:]" | sed -e 's/linux\/riscv64,//') --file Dockerfile --tag maxpeal/minisign:v0.9 --push . --cache-from type=local,src=/tmp/.buildx-cache --cache-to type=local,dest=/tmp/.buildx-cache

#DOCKER_BUILDKIT=1 docker buildx build $progressFlag --platform linux/riscv64 --file Dockerfile.riscv --tag "${TAG}" --push . --cache-from type=local,src=/tmp/.buildx-cache --cache-to type=local,dest=/tmp/.buildx-cache

#DOCKER_BUILDKIT=1 docker buildx build $progressFlag --platform $(docker buildx inspect --bootstrap | grep -i Platforms | cut -d":" -f2 | tr -d "[:space:]" | sed -e 's/linux\/riscv64,//') --file Dockerfile --tag maxpeal/minisign:v0.9 --push . --cache-from type=local,src=/tmp/.buildx-cache --cache-to type=local,dest=/tmp/.buildx-cache


#docker buildx inspect --bootstrap | grep -i Platforms | cut -d":" -f2  | tr "," "\\n" | grep -v linux/amd64 | grep -v linux/riscv64 | \

#echo ${{ secrets.CR_PAT }} | docker login ghcr.io -u $GITHUB_ACTOR --password-stdin
#echo ${DOCKER_PAT_MINISIGN} | docker login -u $DOCKER_USERID_PAT_MINISIGN --password-stdin

# grep -v /etc/*release /etc/*version /etc/os-*


# docker pull --platform linux/riscv64 alpine:latest
# docker run -it --rm --platform linux/riscv64 tonistiigi/debian:riscv
# docker pull --platform linux/arm alpine:latest
# docker run -it --rm --platform linux/arm alpine:latest

set -eu
line="linux/amd64"
DOCKER_BUILDKIT=1 docker buildx build $progressFlag --platform ${line} --file Dockerfile --tag "${TAG}" --push . --cache-from type=local,src=/tmp/.buildx-cache --cache-to type=local,dest=/tmp/.buildx-cache

docker buildx inspect --bootstrap | grep -i Platforms | cut -d":" -f2  | tr "," "\\n" | \
	while read -r line; do
DOCKER_BUILDKIT=1 docker buildx build $progressFlag --platform ${line} --file Dockerfile --tag "${TAG}" --push . --cache-from type=local,src=/tmp/.buildx-cache --cache-to type=local,dest=/tmp/.buildx-cache \		|| DOCKER_BUILDKIT=1 docker buildx build $progressFlag --platform ${line} --file Dockerfile.riscv --tag "${TAG}" --push . --cache-from type=local,src=/tmp/.buildx-cache --cache-to type=local,dest=/tmp/.buildx-cache
	
	
	  # cat Dockerfile.busybox | docker buildx build $progressFlag --platform ${line} --tag testbox --progress plain - \
  # || cat Dockerfile.debian-stable-slim | docker buildx build $progressFlag --platform ${line} --tag testbox - \
  # || cat Dockerfile.debian-testing-slim | docker buildx build $progressFlag --platform ${line} --tag testbox - \
  # || cat Dockerfile.debian-unstable-slim | docker buildx build $progressFlag --platform ${line} --tag testbox - \
  # || cat Dockerfile.tonistiigi-debian | docker buildx build $progressFlag --platform ${line} --tag testbox - \
  # || cat Dockerfile.tonistiigi-debian-riscv | docker buildx build $progressFlag --platform ${line} --tag testbox - #\
  # #|| true
	done


