CLUSTER_NAME=goplayground
NAMESPACE=resumable-upload
SVC_VERSION=0.0.1
PROMETHEUS_IMAGE=prom/prometheus
GRAFANA_IMAGE=grafana/grafana:latest

clean:
		kind delete cluster --name=${CLUSTER_NAME}

clean-namespace:
		kubectl delete namespace ${NAMESPACE}

clean-resources:
		kubectl delete all --all -n ${NAMESPACE}

cluster:
		kind create cluster --config=k8s/local-dev/kind/cluster-config.yaml --name=${CLUSTER_NAME}

		# NOTE: currently this needs to be run twice to work correctly. Not sure why


# This is a time consuming operation. Builds all components, creates docker images and loads images into Kind cluster
publish: pullDependencies publishTusd
publishTusd:
		docker build -t resumable-upload/tusd:${SVC_VERSION} .

pullDependencies:
		docker pull ${PROMETHEUS_IMAGE}
		docker pull ${GRAFANA_IMAGE}

loadImage: loadDependentImage loadServiceImage

loadDependentImage:
		kind load docker-image  ${PROMETHEUS_IMAGE} --name=${CLUSTER_NAME}
		kind load docker-image ${GRAFANA_IMAGE} --name=${CLUSTER_NAME}

loadServiceImage:
		kind load docker-image resumable-upload/tusd:${SVC_VERSION}  --name=${CLUSTER_NAME}

apply: applyDependencies applyServices

applyServices:
		kubectl apply -k k8s/local-dev/tusd -n ${NAMESPACE}

applyDependencies:
		kubectl apply -k k8s/local-dev/prometheus -n ${NAMESPACE}
		kubectl apply -k k8s/local-dev/grafana -n ${NAMESPACE}

deploy: publish apply		

unApply: unapplyServices unApplyDependencies

unApplyDependencies:
		kubectl delete jobs --all -n ${NAMESPACE}
		kubectl delete deployment prometheus-deployment -n ${NAMESPACE}
		kubectl delete deployment grafana -n ${NAMESPACE}
unapplyServices:
		kubectl delete deployment tusd -n ${NAMESPACE}


#re-Deploy Single service
.PHONY: reDeploy
reDeploy:
	kubectl delete deployment ${service} --ignore-not-found=true -n ${NAMESPACE}
	docker build -t resumable-upload/tusd:${SVC_VERSION} .
	kind load docker-image resumable-upload/${service}:${SVC_VERSION}  --name=${CLUSTER_NAME}
	kubectl apply -k k8s/local-dev/${service} -n ${NAMESPACE}
