#!/bin/sh

helm template ./deploy/chart --set version=$VERSION > output.yaml
cat output.yaml
kubectl apply -f output.yaml
