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
        -n | --none)
            return
            ;;
        -h | --help)
            echo -ne "\\nFirefox UserJS helper:
                                 -g, --gnome: apply GNOME userchrome theme
                                 -h, --help: display this message
                                 -m, --materialFox: apply MaterialFox userchrome theme
                                 -n, --none: no theme\\n"
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
        echo "-> Copying user.js to profile: ${profile}..."
        mkdir -p "${HOME}/.config/firefox/${profile}"
        cp ./user.js "${HOME}/.config/firefox/${profile}"
    done

    echo "Copying profiles.ini..."
    mkdir -p "${HOME}/.mozilla/firefox"
    cp ../../profiles.ini "${HOME}/.mozilla/firefox/"

    echo "Copying policies.json (may need root permissions)..."

    if [[ -d /usr/lib/firefox/distribution ]]; then
        sudo cp ../../policies.json /usr/lib/firefox/distribution
    elif [[ -d /opt/firefox-nightly ]]; then
        sudo chown -R ${USER}:${USER} /opt/firefox-nightly
        cp ../../policies.json /opt/firefox-nightly/distribution
    elif [[ -d /opt/firefox-developer-edition ]]; then
        cp ../../policies.json /opt/firefox-developer-edition/distribution
    fi
}

cleanUp() {
    cd ../../
    echo "Cleaning up after myself..."
    rm -rf ./workdir
}

startFirefox() {
    $(command -v firefox) --ProfileManager
}

main() {
    createWorkDir
    fetchGHacksJS
    mkTweaks "${1}"
    applyToProfiles
    cleanUp
    startFirefox

    echo "Firefox is setup and started. Have a good day!"
}

main "${1}"
