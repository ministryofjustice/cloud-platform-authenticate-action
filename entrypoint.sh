#!/bin/sh -l

echo -n ${K8S_CLUSTER_CERT} | base64 -d > ./ca.crt
kubectl config set-cluster ${K8S_CLUSTER_NAME} --certificate-authority=./ca.crt --server=https://api.${K8S_CLUSTER_NAME}
kubectl config set-credentials ${SERVICE_ACCOUNT} --token=${K8S_TOKEN}
kubectl config set-context ${K8S_CLUSTER_NAME} --cluster=${K8S_CLUSTER_NAME} --user=${SERVICE_ACCOUNT} --namespace=${K8S_NAMESPACE}
kubectl config use-context ${K8S_CLUSTER_NAME}

result="$(kubectl $1)"

status=$?
echo ::set-output name=result::$result
echo "$result"
if [[ $status -eq 0 ]]; then exit 0; else exit 1; fi
