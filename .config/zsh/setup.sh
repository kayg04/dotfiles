#!/usr/bin/env bash

set -euo pipefail

installOMZ() {
    if [[ ! upgrade_oh_my_zsh || ! -d "${HOME}/.oh-my-zsh" ]]; then
        sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    else
        exit 1
    fi
}

importDef() {
    echo 'source ${HOME}/.config/zsh/*.zsh 2>/dev/null 1>&2' >> "${HOME}/.zshrc"
}

main() {
    installOMZ
    importDef
}

main
