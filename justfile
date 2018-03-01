# vim: set ft=make :

help:
	@echo "just is a convenient command runner. Try just -l"

docker +ARGS:
	#!/bin/bash
	set -eu
	set -o pipefail

	# When not in a justfile set the directory
	# cd "$( dirname "$0" )/.."
	IMAGE="pingcap/tikv:local"

	DOCKER_ARGS=${DOCKER_ARGS:-""}
	docker run -it --rm $DOCKER_ARGS \
		-v "$PWD:$PWD" -w "$PWD" \
		-v "$PWD/.cargo:/root/.cargo" \
		"$IMAGE" {{ARGS}}

# Setup the development docker image
setup-docker:
	#!/bin/bash
	set -euo pipefail
	set -x
	pushd docker
	docker build -t pingcap/tikv:local -f rust_dockerfile .
	popd
	rm -rf .cargo || sudo rm -rf .cargo
	container=$(docker run -d --rm pingcap/tikv:local sleep 1000)
	trap "docker rm -f $container" EXIT
	docker cp "$container:/root/.cargo" .cargo/
	# docker run -i --rm -w /root/.cargo pingcap/tikv:local tar cf - . | (cd .cargo && tar xBf -)
