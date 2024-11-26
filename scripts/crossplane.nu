#!/usr/bin/env nu

def create_crossplane [] {

    helm repo add crossplane https://charts.crossplane.io/stable

    (
        helm upgrade --install crossplane crossplane/crossplane
            --namespace crossplane-system --create-namespace
            --wait
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
