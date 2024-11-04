# Demo Manifests and Code Used in DevOps Toolkit Videos

[![From Docker to Kubernetes: Running Backstage in Production!](https://img.youtube.com/vi/fLAVFQAhzM4/0.jpg)](https://youtu.be/fLAVFQAhzM4)tps://youtu.be/A-3Ai--Z-Gs)

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
