#!/usr/bin/env bash
# Enable extended globbing
shopt -s extglob dotglob nullglob

# Add all files in $HOME/.ssh/keys that do not end
# with .pub
ssh-add "${HOME}"/.ssh/keys/!(*.pub) </dev/null
