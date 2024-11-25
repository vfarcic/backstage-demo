#!/usr/bin/env nu

def create_crossplane [] {

    (
        helm upgrade --install crossplane crossplane
            --repo https://charts.crossplane.io/stable
            --namespace crossplane-system --create-namespace --wait
    )

    (
        kubectl apply
            --filename crossplane/config-dot-application.yaml
    )

    (
        kubectl apply
            --filename crossplane/provider-helm-incluster.yaml
    )

    (
        kubectl apply
            --filename crossplane/provider-kubernetes-incluster.yaml
    )

}
