IMAGE=nikkoura/restic
ARCH=arm64

default: image push manifest

image:
		docker build -t ${IMAGE}:${ARCH} .

push: image
		docker push ${IMAGE}:${ARCH}

manifest: push
		manifest-tool push from-args --platforms linux/arm64 --template ${IMAGE}:ARCH --target ${IMAGE}
