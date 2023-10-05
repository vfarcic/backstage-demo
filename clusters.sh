#!/bin/sh

set -e

rm -f kubeconfig*.yaml

gum style \
        --foreground 212 --border-foreground 212 --border double \
        --margin "1 2" --padding "2 4" \
        'Create Kubernetes clusters in Civo'

echo "
## You will need following tools installed:
|Name            |Required             |More info                                          |
|----------------|---------------------|---------------------------------------------------|
|civo CLI        |Yes                  |'https://github.com/civo/cli'                      |
" | gum format

gum confirm "
Do you have those tools installed?
" || exit 0

CLUSTERS_COUNT=$(gum input \
    --placeholder "How many clusters do you need?" \
    --value "$CLUSTERS_COUNT")
echo "export CLUSTERS_COUNT=$CLUSTERS_COUNT" >> .env

for ((COUNTER = 1; COUNTER <= $CLUSTERS_COUNT; COUNTER++)); do

    civo kubernetes create dot-$COUNTER --size g4s.kube.medium \
        --remove-applications=Traefik-v2-nodeport \
        --applications civo-cluster-autoscaler \
        --nodes 1 --region NYC1 --yes --wait

    export KUBECONFIG=$PWD/kubeconfig-$COUNTER.yaml

    sleep 10

    civo kubernetes config dot-$COUNTER --region NYC1 \
        --local-path $KUBECONFIG --save

    chmod 400 $KUBECONFIG

    helm upgrade --install traefik traefik \
        --repo https://helm.traefik.io/traefik \
        --namespace traefik --create-namespace --wait

done
