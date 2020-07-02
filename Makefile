

all: build

build: 
	echo "docker-build-toolchain or docker-build"

DOCKER_TOOLCHAIN_IMAGE := "onlykey/onlykey-firmware-toolchain"

docker-build-toolchain:
	docker build -t $(DOCKER_TOOLCHAIN_IMAGE) .
	docker tag $(DOCKER_TOOLCHAIN_IMAGE):latest $(DOCKER_TOOLCHAIN_IMAGE):${SOLO_VERSION}
	docker tag $(DOCKER_TOOLCHAIN_IMAGE):latest $(DOCKER_TOOLCHAIN_IMAGE):${SOLO_VERSION_MAJ}
	docker tag $(DOCKER_TOOLCHAIN_IMAGE):latest $(DOCKER_TOOLCHAIN_IMAGE):${SOLO_VERSION_MAJ}.${SOLO_VERSION_MIN}

docker-build:
	docker run --rm -v "$(CURDIR)/builds:/builds" \
					-v "$(CURDIR):/onlykey" \
					-u $(shell id -u ${USER}):$(shell id -g ${USER}) \
				    $(DOCKER_TOOLCHAIN_IMAGE) "onlykey/in-docker-build.sh" ${SOLO_VERSION_FULL}


	
