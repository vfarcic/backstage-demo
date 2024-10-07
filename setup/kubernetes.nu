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

try {(
    docker login --username $github_token 
        --password $github_token ghcr.io
)}

open chart/Chart.yaml
    | upsert version "0.0.1"
    | upsert appVersion "0.0.1"
    | save chart/Chart.yaml --force

open chart/values.yaml
    | upsert image.repository $"ghcr.io/($github_user)/backstage-demo"
    | upsert appVersion "0.0.1"
    | save chart/values.yaml --force

kind create cluster --config kind.yaml

(
    kubectl apply
        --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml
)

start $"https://github.com/($github_user)/backstage-demo/settings/actions"

print $"Select (ansi yellow_bold)Read and write permissions(ansi reset) from the (ansi yellow_bold)Workflow permissions(ansi reset) section in browser, and click the (ansi yellow_bold)Save(ansi reset) button."
