ENV=poc-dev1
NAMESPACE=helm-${ENV}-platform

BRANCH_ID="zxc001"

HELM_NAME=${NAMESPACE}-macroservice
if [ $BRANCH_ID ]
then
  HELM_NAME=${HELM_NAME}-${BRANCH_ID}
fi
echo $HELM_NAME

helm template ./argocd-poc-helm-guestbook \
  --namespace=${NAMESPACE} --set global.k8sEnv=$ENV \
  --set branchIdentifier=$BRANCH_ID

helm upgrade --install $HELM_NAME ./argocd-poc-helm-guestbook \
  --namespace=${NAMESPACE} \
  --set global.k8sEnv=$ENV \
  --set branchIdentifier=$BRANCH_ID

helm list --namespace=$NAMESPACE
kubectl get pods,services --namespace=$NAMESPACE

#cleanup
ENV=poc-prod2
NAMESPACE=helm-${ENV}-platform
helm del --namespace $NAMESPACE $(helm ls --namespace $NAMESPACE --all --short)
helm ls --namespace $NAMESPACE


kubectl get pods,services --namespace=argocd-poc-dev1-platform
kubectl get pods,services --namespace=argocd-poc-qad1-platform
kubectl get pods,services --namespace=argocd-poc-prod1-platform
kubectl get pods,services --namespace=argocd-poc-prod2-platform

mkdir argocd-poc-dev1-platform
mkdir argocd-poc-qad1-platform
mkdir argocd-poc-prod1-platform
mkdir argocd-poc-prod2-platform



ENV=poc-dev1
NAMESPACE=argocd-${ENV}-platform

BRANCH_ID="zxc001"

HELM_NAME=${NAMESPACE}-macroservice

MANIFEST_DIR=namespaces/${NAMESPACE}/macroservice
if [ $BRANCH_ID ]
then
  MANIFEST_DIR=${MANIFEST_DIR}-${BRANCH_ID}
fi
echo $MANIFEST_DIR

mkdir $MANIFEST_DIR
helm template ./argocd-poc-helm-guestbook \
  --namespace=${NAMESPACE} --set global.k8sEnv=$ENV \
  --set branchIdentifier=$BRANCH_ID \
  > argocd-poc-gitops/${MANIFEST_DIR}/manifest.yaml

argocd app create $HELM_NAME \
  --repo https://github.com/jagannathan-m/argocd-poc-gitops.git \
  --path ${MANIFEST_DIR} \
  --dest-server https://kubernetes.default.svc --dest-namespace ${NAMESPACE}
