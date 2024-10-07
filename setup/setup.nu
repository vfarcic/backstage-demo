#!/usr/bin/env nu

(
    yarn --cwd backstage/packages/backend add
        @backstage/plugin-scaffolder-backend-module-github
)

(
    yarn --cwd backstage/packages/backend add
        @backstage/plugin-catalog-backend-module-github
)

(
    cp packages/backend/src/index.ts
        backstage/packages/backend/src/index.ts
)

mut github_token = ""
if "GITHUB_TOKEN" not-in $env {
    $github_token = input $"(ansi green_bold)Enter GitHub token:(ansi reset)"
} else {
    $github_token = $env.GITHUB_TOKEN
}
$"export GITHUB_TOKEN=($github_token)\n" | save --append .env

mut github_user = ""
if "GITHUB_TOKEN" not-in $env {
    $github_user = input $"(ansi green_bold)Enter GitHub user or organization where you forked the repo:(ansi reset)"
} else {
    $github_user = $env.GITHUB_USER
}
$"export GITHUB_USER=($github_user)\n" | save --append .env

kind create cluster --config kind.yaml

(
    kubectl apply
        --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
)

kubectl create namespace backstage

echo $"
apiVersion: v1
kind: Secret
metadata:
  name: backstage-backstage-demo
  namespace: backstage
type: Opaque
data:
  GITHUB_TOKEN: ($github_token | base64)
  GITHUB_USER: ($github_user | base64)
" | kubectl --namespace backstage apply --filename -

(
    helm upgrade --install cnpg cloudnative-pg
        --repo https://cloudnative-pg.github.io/charts
        --namespace cnpg-system --create-namespace --wait
)

let tag = open chart/Chart.yaml | get version
$"export TAG=($tag)\n" | save --append .env
