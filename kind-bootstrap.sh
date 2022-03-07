#!/bin/bash

ENV=dev
kind delete cluster --name $ENV
kind create cluster --name $ENV --config kind-config.yaml

kubectl --context kind-$ENV create ns flux-system

kubectl --context kind-$ENV create secret generic sops-gpg \
--namespace=flux-system \
--from-file=sops.asc=clusters/kind-$ENV/sops.asc

. ~/.github-token

# Run bootstrap for a repository path
flux bootstrap github \
--context=kind-$ENV \
--owner=dev-samples \
--repository=sample-flux \
--branch=sample-01-variable-substitution-debug \
--path=clusters/kind-$ENV



# kustomize build /home/user/repos/sample-flux/apps/kind-dev