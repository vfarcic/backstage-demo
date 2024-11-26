#!/usr/bin/env nu

source ../scripts/kubernetes.nu
source ../scripts/ingress.nu
source ../scripts/cnpg.nu
source ../scripts/crossplane.nu
source ../scripts/github.nu
source ../scripts/backstage.nu

rm --force .env

create_kubernetes kind

apply_ingress kind nginx

create_crossplane

create_cnpg false

let github_data = get_github_auth

apply_backstage $github_data.github_user $github_data.github_token
