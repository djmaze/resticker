IMAGE=mazzolino/restic
ARCH=amd64

default: image push manifest

image:
		docker build -t ${IMAGE}:${ARCH} .

push: image
		docker push ${IMAGE}:${ARCH}

manifest: push
		manifest-tool push from-args --platforms linux/amd64,linux/arm --template ${IMAGE}:ARCH --target ${IMAGE}
