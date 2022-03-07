#!/bin/bash


# Create a simple dummy username/password secret
kubectl create secret generic my-secret \
--from-literal=username=user \
--from-literal=password=secret \
-o yaml --dry-run=client > my-secret-input.yaml

# Example encrypting the dummy secret using sops
# gpg --list-secret-keys kind-dev@local.com
gpg --import /home/user/repos/sample-flux/clusters/kind-dev/sops.pub.asc

# Use public key to encrypt
sops --encrypt \
--encrypted-regex '^(data|stringData)$' \
--pgp='735193D6A6BF6D8A6A5C2578A15D02AC0678B090' \
my-secret-input.yaml > \
my-secret.yaml
