# Alcina Engineering Website

Base image can be build from https://github.com/nginxinc/docker-nginx-amplify.git

## Hugo

This site is generated with `hugo` with the Massively theme. It uses a
fork of the https://github.com/curttimson/hugo-theme-massively which is
found at https://github.com/Smirl/hugo-theme-massively.

Add new pages into `content/post`.

## Deployment

Deployment is to a kubernetes cluster. A few steps need to be done including
secret and service account set up. There are also manual deployment steps for
reference.

### Travis CI

Master commits trigger travis to build a docker image, push this to the registry,
template a helm chart, and then deploy the manifest. Info on the pipeline is in
the `.travis.yml`. It needs registry and kubernetes credentials as secret env
vars. It also needs a service account to deploy, with the correct RBAC.

To create the service account and permissions, a cluster-admin needs to apply
the following:

    kubectl apply -f deploy/serviceaccount.yaml

There are a few secrets setup for travis ci. `deploy/kubeconfig.enc` checked in
to the repo, however it's unencrypted form `deploy/kubeconfig` is not. This
can be recreated with:

    kubectl config view --minify --raw -o json | jq -r '.clusters[0].cluster."certificate-authority-data"' | base64 -D > deploy/ca.crt
    kubectl config set-cluster travis --server=XXXX --certificate-authority=./deploy/ca.crt --embed-certs
    kubectl config set-credentials travis --token XXXXXX
    kubectl config set-context travis --cluster=travis --user=travis --namespace alcinaengineering
    kubectl config use-context travis
    kubectl config view --raw --minify > deploy/kubeconfig
    travis encrypt-file deploy/kubeconfig deploy/kubeconfig.enc --add

For the registry:

    travis encrypt DOCKER_PASSWORD=XXXXX --add

## Secrets

The following secrets need to be in the deployment namespace.

    kubectl create secret docker-registry registry.smirlwebs.com --docker-server=registry.smirlwebs.com --docker-username=XXXXX --docker-password=XXXXXXX --docker-email=smirlie@googlemail.com
    
    kubectl create secret generic amplify --from-literal=api_key=XXXXXXXX

### Manually
To deploy build the docker image, being sure to change the version:

    docker build -t registry.smirlwebs.com/smirl/alcina:1.0.0 .

Login to the cluster:

    doctl kubernetes cluster kubeconfig save ...
    kubectl ns alcina

If not already created, add the secrets from the steps above.

Then apply to kubernetes, again remember to change the version and commit:

    helm template ./deploy/chart --set VERSION=1.0.x > output.yaml
    kubectl apply -f output.yaml
