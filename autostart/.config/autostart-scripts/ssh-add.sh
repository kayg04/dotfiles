#!/usr/bin/env bash
# Enable extended globbing
shopt -s extglob dotglob nullglob

# Add all files in the keys directory that do not end with .pub
ssh-add "${HOME}"/.vault/ssh/login/!(*.pub) </dev/null
