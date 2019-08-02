#!/usr/bin/env bash

set -euo pipefail

createWorkDir() {
    if [[ -d ./workdir ]]; then
        rm -rf ./workdir
    fi

    mkdir -p ./workdir
    cd ./workdir
}

fetchGHacksJS() {
    git clone https://github.com/ghacksuserjs/ghacks-user.js.git ./ghjs
    cd ./ghjs
}

mkTweaks() {
    cp ../../*.js ./

    case "${1}" in
        -m | --materialFox)
            cat ./materialfox.js >> ./user-overrides.js
            break
            ;;
        -g | --gnome)
            cat ./gnome.js >> ./user-overrides.js
            break
            ;;
        -h | --help)
            echo -ne "\\nFirefox UserJS helper:
                                 -g, --gnome: apply GNOME userchrome theme
                                 -h, --help: display this message
                                 -m, --materialFox: apply MaterialFox userchrome theme\\n"
            break
            ;;
        *)
            echo -ne "\\nInvalid flag. Pass -h or --help for usage.\\n"
    esac

    ./updater.sh -s
}

applyToProfiles() {
    profileList=$(cat ../../profiles.ini | grep -i 'Name' | cut -d '=' -f 2 | awk '{print tolower($0)}')

    for profile in ${profileList}; do
        mkdir -p "${HOME}/.config/firefox/${profile}"
        cp ./user.js "${HOME}/.config/firefox/${profile}"
    done
}

cleanUp() {
    cd ../../
    rm -rf ./workdir
}

main() {
    createWorkDir
    fetchGHacksJS
    mkTweaks "${1}"
    applyToProfiles
    cleanUp
}

main "${1}"
