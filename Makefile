IMAGE_NAME = spec-analysis
IMAGE_VERSION = 0.0.0
IMAGE_LABEL = v$(IMAGE_VERSION)

DOCKER = docker

.PHONY: build-heasoft
build-heasoft:
	wget https://heasarc.gsfc.nasa.gov/FTP/software/lheasoft/release/heasoft-6.31.1docker0.92.tar
	install -d heasoft
	tar xvf heasoft-6.31.1docker0.92.tar -C heasoft/
	cd heasoft && $(MAKE)
	

build: build-heasoft
	@echo "Building Docker image ${IMAGE_NAME}:${IMAGE_LABEL}..."
	-$(DOCKER) build --network=host --build-arg version=$(IMAGE_VERSION) -t $(IMAGE_NAME):$(IMAGE_LABEL) .

latest: image
	@echo "Tagging Docker image ${IMAGE_NAME}:${IMAGE_LABEL} with latest..."
	-$(DOCKER) tag `$(DOCKER) image ls --format '{{.ID}}' $(IMAGE_NAME):$(IMAGE_LABEL)` $(IMAGE_NAME):latest

run:
	@echo "Running Docker image ${IMAGE_NAME}:${IMAGE_LABEL}..."
	docker run --rm -it --network=host ${IMAGE_NAME}:${IMAGE_LABEL} ${SHELL}

.PHONY: clean
clean:
	rm -rf heasoft/ heasoft-*




