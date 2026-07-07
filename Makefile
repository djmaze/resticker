IMAGE=mazzolino/restic
ARCH=amd64
CONTAINER_RUNTIME?=docker

default: image push manifest

image:
		${CONTAINER_RUNTIME} build -t ${IMAGE}:${ARCH} --build-arg ARCH=${ARCH} .

push: image
		${CONTAINER_RUNTIME} push ${IMAGE}:${ARCH}

manifest: push
		manifest-tool push from-args --platforms linux/amd64,linux/arm,linux/arm64 --template ${IMAGE}:ARCH --target ${IMAGE}
