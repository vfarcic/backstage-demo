#!/usr/bin/env nu

def apply_backstage [github_user: string, github_token: string] {

    kubectl create namespace backstage

    $"
apiVersion: v1
kind: Secret
metadata:
  name: backstage-backstage-demo
  namespace: backstage
type: Opaque
data:
  GITHUB_TOKEN: (($github_token) | base64)
  GITHUB_USER: (($github_user) | base64)
" | kubectl --namespace backstage apply --filename -

    (
        helm upgrade --install backstage
            oci://ghcr.io/vfarcic/backstage-demo/backstage-demo
            --version 0.0.41 --namespace backstage --create-namespace
            --set mode=production --wait
    )

}
