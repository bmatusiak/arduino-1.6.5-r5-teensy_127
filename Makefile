

all: build

build: 
	echo "docker-build-toolchain or docker-build"

DOCKER_TOOLCHAIN_IMAGE := "onlykey/onlykey-firmware-toolchain"

docker-build-toolchain:
	docker build -t $(DOCKER_TOOLCHAIN_IMAGE) .

docker-build:
	docker run --rm -v "$(CURDIR)/builds:/builds" \
					-v "$(CURDIR):/onlykey" \
					-u $(shell id -u ${USER}):$(shell id -g ${USER}) \
				    $(DOCKER_TOOLCHAIN_IMAGE) "onlykey/in-docker-build.sh" ${SOLO_VERSION_FULL}


	
