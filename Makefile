

all: build

build: 
	@echo "Build Docker Image for building"
	@echo "make docker-build-toolchain"
	@echo ""
	@echo "build firmware"
	@echo "make docker-build"
	@echo ""
	@echo "build firmware from local files"
	@echo "make docker-build-local"
	@echo ""
	@echo "Build firmware from fork(default is trustcrypto) and branch(default is master)"
	@echo "fork=trustcrypto branch=master make docker-build"
	@echo ""
	@echo "Build firmware from tag"
	@echo "branch=v0.2-beta.8 make docker-build"

DOCKER_TOOLCHAIN_IMAGE := "onlykey/onlykey-firmware-toolchain"

docker-build-toolchain:
	docker build -t $(DOCKER_TOOLCHAIN_IMAGE) .

docker-build:
	docker run --rm -v "$(CURDIR)/builds:/builds" \
					-v "$(CURDIR):/onlykey" \
					-u $(shell id -u ${USER}):$(shell id -g ${USER}) \
				    $(DOCKER_TOOLCHAIN_IMAGE) "onlykey/in-docker-build.sh" $(branch) $(fork)

docker-build-local:
	docker run --rm -v "$(CURDIR)/builds:/builds" \
					-v "$(CURDIR):/onlykey" \
					-u $(shell id -u ${USER}):$(shell id -g ${USER}) \
				    $(DOCKER_TOOLCHAIN_IMAGE) "onlykey/in-docker-build.sh" local

	
