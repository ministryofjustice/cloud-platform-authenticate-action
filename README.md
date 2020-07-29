# Cloud Platform Authentication Action

This is a Github Action for authenticating against Cloud Platform Kubernetes cluster Service Accounts.

## Required

- K8S_CLUSTER_NAME - the full name of the cluster.
- K8S_NAMESPACE - the name of the Namespace.
- K8S_CLUSTER_CERT - the CA Certificate for the cluster, can be acquired from the Secret that is generated for the ServiceAccount. Base64 encoded.
- K8S_TOKEN - the access token generated for the ServiceAccount. This needs to be base64 decoded.
- SERVICE_ACCOUNT - the ServiceAccount that will be used to authenticate against.

