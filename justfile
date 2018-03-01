# vim: set ft=make :

help:
	@echo "just is a convenient command runner. Try just -l"

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
