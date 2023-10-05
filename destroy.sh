#!/bin/sh

set -e

source .env

gum style \
        --foreground 212 --border-foreground 212 --border double \
        --margin "1 2" --padding "2 4" \
        'Destroy Kubernetes clusters in Civo'

echo "
## You will need following tools installed:
|Name            |Required             |More info                                          |
|----------------|---------------------|---------------------------------------------------|
|civo CLI        |Yes                  |'https://github.com/civo/cli'                      |
" | gum format

gum confirm "
Do you have those tools installed?
" || exit 0

for ((COUNTER = 1; COUNTER <= $CLUSTERS_COUNT; COUNTER++)); do

    civo kubernetes remove dot-$COUNTER --region NYC1 --yes

    rm -f kubeconfig-$COUNTER.yaml

    sleep 10

    civo firewall ls --region NYC1 --output custom --fields "name" | grep dot-$COUNTER | \
        while read FIREWALL; do
            civo firewall rm $FIREWALL --region NYC1 --yes
        done

    civo volume ls --region NYC1 --dangling --output custom --fields "name" | \
        while read VOLUME; do
            civo volume rm $VOLUME --region NYC1 --yes
        done

done
