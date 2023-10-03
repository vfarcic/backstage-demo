## Prerequisites

* Install `gum` by following the instructions in https://github.com/charmbracelet/gum#installation.
* Watch https://youtu.be/U8zCHA-9VLA if you are not familiar with Charm Gum.

## Create Clusters

```bash
chmod +x clusters.sh

# TODO: Send emails to the attendees with the instructions how to
#   use the clusters and the tools that should be installed.
./clusters.sh
```

## Demo Setup

* Install `gum` by following the instructions in https://github.com/charmbracelet/gum#installation.
* Watch https://youtu.be/U8zCHA-9VLA if you are not familiar with Charm Gum.

```bash
chmod +x setup.sh

./setup.sh

source .env
```

## Create Your Own Backstage Component

1. Copy the `users-api/users-app-component.yaml` to `/catalog`
``` bash
cp users-api/users-app-component.yaml to catalog/new-app.yaml
```
2. Edit the `catalog/new-app.yaml` based on the component configuration 
3. Add an Entry to `/catalog/catalog-all.yaml`
```
    - ./new-app.yaml
```
4. Create a relation between to components, by adding the following configuration to one of the components - [example](https://github.com/backstage/backstage/blob/658a41574809707c902ae00ec6da13da66905d52/packages/catalog-model/examples/components/artist-lookup-component.yaml#L38).
```
spec:
  dependsOn: ['component:db']
```
5. Add links to component by adding the following configuration - [example](https://github.com/backstage/backstage/blob/658a41574809707c902ae00ec6da13da66905d52/packages/catalog-model/examples/components/artist-lookup-component.yaml#L9)
```
metadata:
  links:
  -  url: https://example.com/user
     title: Examples Users
     icon: user
```

## Destroy Clusters

* Install `gum` by following the instructions in https://github.com/charmbracelet/gum#installation.
* Watch https://youtu.be/U8zCHA-9VLA if you are not familiar with Charm Gum.

```bash
chmod +x setup.sh

./setup.sh

source .env
```