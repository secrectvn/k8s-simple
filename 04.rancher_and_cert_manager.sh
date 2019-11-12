echo "Your Email? "
read email
echo "Your Domain? "
read domain

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
kubectl apply -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml
kubectl create namespace cert-manager
kubectl label namespace cert-manager certmanager.k8s.io/disable-validation=true

echo "apiVersion: certmanager.k8s.io/v1alpha1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
  namespace: cert-manager
spec:
  acme:
    email: contact@secrect.xyz
    http01: {}
    privateKeySecretRef:
      name: letsencrypt-prod
    server: https://acme-v02.api.letsencrypt.org/directory" | kubectl apply -f -

helm repo add jetstack https://charts.jetstack.io
helm repo update

helm install \
  --name cert-manager \
  --namespace cert-manager \
  --version v0.11.0 \
  jetstack/cert-manager

kubectl -n cert-manager  rollout status deploy/cert-manager

kubectl get pods --namespace cert-manager

helm install rancher-stable/rancher \
  --name rancher \
  --namespace cattle-system \
  --set hostname=kub3.secrect.xyz \
  --set ingress.tls.source=letsEncrypt \
  --set letsEncrypt.email=contact@secrect.xyz

kubectl -n cattle-system rollout status deploy/rancher