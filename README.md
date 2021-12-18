# Alcina Engineering Website

Alcina Engineering Website found at www.alcinaengineering.co.uk/

## Hugo

This site is generated with `hugo` with the Massively theme. It uses a
fork of the https://github.com/curttimson/hugo-theme-massively which is
found at https://github.com/Smirl/hugo-theme-massively.

Add new pages into `content/post`.

## Deployment

Deployment is to a kubernetes cluster. A few steps need to be done including
secret and service account set up. There are also manual deployment steps for
reference.

The helm chart used is a
[generic-app](https://artifacthub.io/packages/helm/mvisonneau/generic-app)
chart.

### Service Account

A service account is required to allow github-actions access. This is
created with:

```console
kubectl apply -f deploy/serviceaccount.yaml
```

### Github Actions

The `prod` environment needs to be set up with two secrets:

 - `K8S_URL` - url of kubernetes api server
 - `K8s_SECRET` - yaml content of the service account secret


### Secrets

The following secrets need to be in the deployment namespace.
 
    kubectl create secret generic amplify --from-literal=api_key=XXXXXXXX
