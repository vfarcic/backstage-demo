#!/usr/bin/env nu

source ../scripts/kubernetes.nu
source ../scripts/ingress.nu
source ../scripts/cnpg.nu

rm --force .env

create_kubernetes kind

apply_ingress kind nginx

create_cnpg false

let github_data = get_github_auth

$"
apiVersion: v1
kind: Secret
metadata:
  name: backstage-backstage-demo
  namespace: backstage
type: Opaque
data:
  GITHUB_TOKEN: (($github_data.github_token) | base64)
  GITHUB_USER: (($github_data.github_user) | base64)
" | kubectl --namespace backstage apply --filename -

(
    helm upgrade --install backstage
        oci://ghcr.io/vfarcic/backstage-demo/backstage-demo
        --version 0.0.41 --namespace backstage --create-namespace
        --set mode=production --wait
)
