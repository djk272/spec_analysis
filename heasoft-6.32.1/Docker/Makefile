#=============================================================================#
# File Description:
#   Used for building HEASoft Docker image.
#=============================================================================#

IMAGE_NAME = heasoft
IMAGE_VERSION = 6.32.1
IMAGE_LABEL = v$(IMAGE_VERSION)

DOCKER = docker
#DOCKER = sudo docker

# GNU tar required: check for gnutar, gtar, then tar. If the
# TAR environment variable is set, it takes precedence.
GNUTAR	= $(shell which gnutar 2>/dev/null)
GTAR	= $(shell which gtar 2>/dev/null)
DTAR	= $(shell which tar 2>/dev/null)

TAR	?= ${shell if [ "x${GNUTAR}" != "x" ]; then echo "${GNUTAR}"; elif [ "x${GTAR}" != "x" ]; then echo "${GTAR}"; elif [ "x${DTAR}" != "x" ]; then echo "${DTAR}"; fi}

TARV	= $(shell ${TAR} --version 2>/dev/null | grep -ic 'gnu tar')

image:
	@-if [ ${TARV} = 0 ]; then \
		echo "GNU tar is required, exiting"; \
		exit 1; \
	else \
		echo "Building Docker image ${IMAGE_NAME}:${IMAGE_LABEL}..."; \
		$(TAR) cz Dockerfile -C ../../ $(IMAGE_NAME)-$(IMAGE_VERSION) | $(DOCKER) build --build-arg version=$(IMAGE_VERSION) -t $(IMAGE_NAME):$(IMAGE_LABEL) -; \
	fi

latest: image
	@echo "Tagging Docker image ${IMAGE_NAME}:${IMAGE_LABEL} with latest..."
	-$(DOCKER) tag `$(DOCKER) image ls --format '{{.ID}}' $(IMAGE_NAME):$(IMAGE_LABEL)` $(IMAGE_NAME):latest
