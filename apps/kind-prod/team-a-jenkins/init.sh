#!/bin/bash

TMP_FILE='/home/user/temp/secrets/ssh-credentials.yml'
#TMP_FILE2='/home/user/temp/secrets/ssh-credentials2.yml'

SOPS_PUB_KEY='/home/user/repos/sample-cluster/clusters/kind-dev/sops.pub.asc'
ENCRYPTED_SECRET='/home/user/repos/sample-cluster/tenants/kind-dev/project-a/ssh-credentials.yml'

# For now/demo purposes we just use local ones
#kubectl -n project-a create secret generic ssh-credentials \
#--from-file=ssh-privatekey=/home/user/.ssh/id_rsa \
#--from-file=ssh-publickey=/home/user/.ssh/id_rsa.pub \
#--dry-run=client \
#-o yaml > $TMP_FILE

# above gives this error:
# auth error: invalid 'ssh-credentials' secret data: required fields 'identity' and 'known_hosts'"}



# Or ...
flux -n project-a create secret git ssh-credentials \
    --url=ssh://git@bitbucket.org/jserup/sample-spring-boot-app.git \
    --export > $TMP_FILE

# Pub key is - e.g. add to bitbucket:
# ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBlQCeFNU/KrkjtRPcCCY7sUOU0nOxUSEfwlUmzn/MXdcm3Pg16qCAhoILH/NgiYeHUyhHmFhLiv2vKtRYWT7nJy8mL8m4xf4PR0DjMYomxY9b3r9nyj0K4/qSc+lQ+5pmk5hc4hkk187a+zs1uv3Ot94qCT2GPczyQpZQHZfQc09GPnVqW/7puuQNipZVDqLZXVPjysdQJtrcjPEOsEwJ0a1Ft6wVbbYjbiqXq7fqFntR1NSo0JdYU3HPd99QDxYcW8WYkt+nVBrnUJBvqZCkaHYvj0Ol4DbgHeRvU+/aRP132g+CatiU440+DyjFuqRXomOCSi1DuKRWqIxvI4sD

# Locate public key for sops in this cluster:
gpg --import $SOPS_PUB_KEY
gpg --list-secret-keys

# Use public key to encrypt
sops --encrypt \
--encrypted-regex '^(data|stringData)$' \
--pgp=42BAF1A0DE5DD12A43DC3A6C045C2BB14F44319E \
$TMP_FILE > \
$ENCRYPTED_SECRET


# Commit the encrypted secret
# ... git lalal

# Remove local content with sensitive information!
# rm -rf /home/user/temp/secrets/registry-secret.yml
