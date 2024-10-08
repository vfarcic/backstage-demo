#!/usr/bin/env nu

rm --force .env

rm --recursive --force backstage

print $"We are about to create a new (ansi yellow_bold)Backstage app(ansi reset). Make sure to respond with the enter key to keep the default value (ansi yellow_bold)backstage(ansi reset) when asked to name the app.
Press (ansi yellow_bold)any key(ansi reset) to continue.
"
input

npx @backstage/create-app@latest

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
if "GITHUB_USER" not-in $env {
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

print ""
print $"
Select (ansi yellow_bold)Read and write permissions(ansi reset) from the (ansi yellow_bold)Workflow permissions(ansi reset) section in browser, and click the (ansi yellow_bold)Save(ansi reset) button.
Press (ansi yellow_bold)any key(ansi reset) to continue.
"
input

start $"https://github.com/($github_user)/backstage-demo/actions"

print $"
(ansi yellow_bold)Enable(ansi reset) GitHub Actions.
Press (ansi yellow_bold)any key(ansi reset) to continue.
"
input
