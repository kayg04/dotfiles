#!/usr/bin/env bash

set -euo pipefail

createWorkDir() {
    if [[ -d ./workdir ]]; then
        rm -rf ./workdir
    fi

    echo "Creating Work Directory..."
    mkdir -p ./workdir
    cd ./workdir
}

fetchGHacksJS() {
    echo "Fetching ghacks user.js..."
    git clone https://github.com/ghacksuserjs/ghacks-user.js.git ./ghjs 2>/dev/null 1>&2
    cd ./ghjs
}

mkTweaks() {
    cp ../../*.js ./

    echo "Applying userchrome tweaks..."
    case "${1}" in
        -m | --materialFox)
            cat ./materialfox.js >> ./user-overrides.js
            ;;
        -g | --gnome)
            cat ./gnome.js >> ./user-overrides.js
            ;;
        -h | --help)
            echo -ne "\\nFirefox UserJS helper:
                                 -g, --gnome: apply GNOME userchrome theme
                                 -h, --help: display this message
                                 -m, --materialFox: apply MaterialFox userchrome theme\\n"
            ;;
        *)
            echo -ne "\\nInvalid flag. Pass -h or --help for usage.\\n"
            exit 1
    esac

    echo "Merging tweaks with ghacks user.js..."
    ./updater.sh -s 2>/dev/null 1>&2
}

applyToProfiles() {
    profileList=$(cat ../../profiles.ini | grep -i 'Name' | cut -d '=' -f 2 | awk '{print tolower($0)}')

    echo "Making profile directories..."
    for profile in ${profileList}; do
        mkdir -p "${HOME}/.config/firefox/${profile}"
        cp ./user.js "${HOME}/.config/firefox/${profile}"
    done

    echo "Copying profiles.ini..."
    mkdir -p "${HOME}/.mozilla/firefox"
    cp ../../profiles.ini "${HOME}/.mozilla/firefox/"

    echo "Copying policies.json..."
    if ! cp ../../policies.json /opt/firefox-nightly/distribution/; then
        echo "Please fix permissions on the firefox-nightly directory by executing:
                     sudo chown -R $USER:$USER /opt/firefox-nightly/"
    fi
}

cleanUp() {
    cd ../../
    echo "Cleaning up after myself..."
    rm -rf ./workdir
}

main() {
    createWorkDir
    fetchGHacksJS
    mkTweaks "${1}"
    applyToProfiles
    cleanUp

    echo "Firefox is setup. Have a good day!"
}

main "${1}"
