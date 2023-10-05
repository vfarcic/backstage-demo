##############
# PostgreSQL #
##############

cat argocd/cnpg.yaml

cp argocd/cnpg.yaml infra/.

git add infra

git commit -m "CPNG"

git push

# Observe CNPG rollout in Argo CD UI

kubectl --namespace cnpg-system get all

cat argocd/backstage-postgresql.yaml

cp argocd/backstage-postgresql.yaml infra/.

git add .

git commit -m "Backstage PostgreSQL"

git push

# Observe PostgreSQL rollout in Argo CD UI

kubectl --namespace backstage get clusters

# The the login credentials for Backstage

export DB_PASS=$(kubectl --namespace backstage \
    get secret backstage-app \
    --output jsonpath="{.data.password}" | base64 --decode)

# Wait for the DB to be created
kubectl --namespace backstage wait pod backstage-1 \
    --for=condition=Ready --timeout=90s

# Repeat the previous command if it errored claiming that the
#   Pod does not exist since that probably means that the Pod
#   was not yet created.

kubectl exec -it --namespace=backstage backstage-1 -- \
    psql -c "\du"

#################
# SealedSecrets #
#################

cat argocd/sealed-secrets-app.yaml

cp argocd/sealed-secrets-app.yaml infra/.

git add infra

git commit -m "Deploy sealed secrets controller"

git push

# Observe SealedSecrets rollout in Argo CD UI

#############
# Backstage #
#############

cat backstage-resources/*.yaml

kubectl --namespace backstage \
    create secret generic backstage-secrets \
    --from-literal POSTGRES_USER=app \
    --from-literal POSTGRES_PASSWORD=$DB_PASS \
    --from-literal GITHUB_TOKEN=$GITHUB_TOKEN \
    --from-literal ARGOCD_AUTH_TOKEN=$ARGOCD_AUTH_TOKEN_ENCODED \
    --dry-run=client --output json

kubectl --namespace backstage \
    create secret generic backstage-secrets \
    --from-literal POSTGRES_USER=app \
    --from-literal POSTGRES_PASSWORD=$DB_PASS \
    --from-literal GITHUB_TOKEN=$GITHUB_TOKEN \
    --from-literal ARGOCD_AUTH_TOKEN=$ARGOCD_AUTH_TOKEN_ENCODED \
    --dry-run=client --output yaml \
    | kubeseal --controller-namespace kubeseal \
    | tee backstage-resources/bs-secret.json

cat argocd/backstage.yaml

cp argocd/backstage.yaml infra/.

git add .

git commit -m "Deploy Backstage"

git push

# Observe the Backstage rollout in ArgoCD

kubectl --namespace backstage get all,secrets

echo "https://$BACKSTAGE_URL"

# Open the URL from the output in a browser

#################
# Deploy An App #
#################

cat users-api/deployment.yaml

cat argocd/users-api.yaml

cp argocd/users-api.yaml apps/.

git add .

git commit -m "deploy users-api"

git push

kubectl get all

##########################
# Add App To The Catalog #
##########################

cat users-api/users-app-component.yaml 

cp users-api/users-app-component.yaml catalog/

yq  --inplace \
    ".spec.targets += \"./users-app-component.yaml\"" \
    catalog/catalog-all.yaml

git add catalog

git commit -m "add users-api to the catalog"

git push

###########
# Destroy #
###########

rm apps/*.yaml

rm infra/*.yaml

git add .

git commit -m "Destroy"

git push
