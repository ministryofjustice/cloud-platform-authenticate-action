#!/bin/sh -l

echo -n ${K8S_CLUSTER_CERT} | base64 -d > ./ca.crt
kubectl config set-cluster ${K8S_CLUSTER_NAME} --certificate-authority=./ca.crt --server=https://api.${K8S_CLUSTER_NAME}
kubectl config set-credentials ${SERVICE_ACCOUNT} --token=${K8S_TOKEN}
kubectl config set-context ${K8S_CLUSTER_NAME} --cluster=${K8S_CLUSTER_NAME} --user=${SERVICE_ACCOUNT} --namespace=${K8S_NAMESPACE}
kubectl config use-context ${K8S_CLUSTER_NAME}

AWS_ACCESS_KEY_ID=$(kubectl get secrets -n ${K8S_NAMESPACE} ${ECR_CREDENTIALS_SECRET} -o json | jq -r '.data["access_key"]' | base64 -d)
AWS_SECRET_ACCESS_KEY=$(kubectl get secrets -n ${K8S_NAMESPACE} ${ECR_CREDENTIALS_SECRET} -o json | jq -r '.data["secret_access_key"]' | base64 -d)
ECR_REPO_URL=$(kubectl get secrets -n ${K8S_NAMESPACE} ${ECR_CREDENTIALS_SECRET} -o json | jq -r '.data["repo_url"]' | base64 -d)

echo ::set-output name=aws_access_key_id::$AWS_ACCESS_KEY_ID
echo ::set-output name=aws_secret_access_key::$AWS_SECRET_ACCESS_KEY
echo ::set-output name=ecr_repo_url::$ECR_REPO_URL

echo ::add-mask::${AWS_ACCESS_KEY_ID}
echo ::add-mask::${AWS_SECRET_ACCESS_KEY}
echo ::add-mask::${ECR_REPO_URL}

result="$(kubectl $1)"

status=$?
echo ::set-output name=result::$result
echo "$result"
if [[ $status -eq 0 ]]; then exit 0; else exit 1; fi
