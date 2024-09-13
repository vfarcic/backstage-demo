# Backstage Demo

## Setup

```sh
devbox shell

chmod +x setup/setup.nu

./setup/setup.nu

source .env
```

## Run Backstage Locally

```sh
cd backstage

yarn dev
```

## Run Backstage in Kubernetes

```sh
helm upgrade --install backstage \
    oci://ghcr.io/vfarcic/backstage-demo/backstage-demo \
    --version $TAG --namespace backstage \
    --set mode=production --wait
```

> Open `http://backstage.127.0.0.1.nip.io` in a browser

## Destroy

```sh
kind delete cluster
```