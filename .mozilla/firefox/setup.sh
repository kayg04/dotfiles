#!/usr/bin/env bash

# import sanity
set -euo pipefail

# global declarations
SCRIPT_PATH=$(dirname $(realpath "${BASH_SOURCE}"))

mkWorkDir() {
    if [[ -d "${SCRIPT_PATH}"/workdir ]]; then
        rm -rf "${SCRIPT_PATH}"/workdir
    fi

    echo "Creating Work Directory..."
    mkdir -p "${SCRIPT_PATH}"/workdir
}

fetchGHacksJS() {
    echo "Fetching ghacks user.js..."
    git clone https://github.com/ghacksuserjs/ghacks-user.js.git "${SCRIPT_PATH}"/workdir/ghjs 2>/dev/null 1>&2
}

mkTweaks() {
    cp "${SCRIPT_PATH}"/*.js "${SCRIPT_PATH}"/workdir/ghjs

    echo "Applying userchrome tweaks..."
    case "${1}" in
        -m | --materialFox)
            cat "${SCRIPT_PATH}"/workdir/ghjs/materialfox.js >> "${SCRIPT_PATH}"/workdir/ghjs/user-overrides.js
            ;;
        -g | --gnome)
            cat "${SCRIPT_PATH}"/workdir/ghjs/gnome.js >> "${SCRIPT_PATH}"/workdir/ghjs/user-overrides.js
            ;;
        -n | --none)
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
    "${SCRIPT_PATH}"/workdir/ghjs/updater.sh -s 2>/dev/null 1>&2
}

updateUserJS() {
    mkWorkDir
    fetchGHacksJS
    mkTweaks -n
}

applyUserJS() {
    profileList=$(cat "${SCRIPT_PATH}"/profiles.ini | grep -i 'Name' | cut -d '=' -f 2 | awk '{print tolower($0)}')

    for profile in ${profileList}; do
        echo "-> Copying user.js to profile: ${profile}..."
        cp "${SCRIPT_PATH}"/workdir/ghjs/user.js "${HOME}/.config/firefox/${profile}"
    done
}

createProfilesINIDir() {
    mkdir -p "${HOME}/.mozilla/firefox"
}

applyProfilesINI() {
    ln -sf "${SCRIPT_PATH}"/profiles.ini "${HOME}/.mozilla/firefox/"
}

createProfiles() {
    profileList=$(cat "${SCRIPT_PATH}"/profiles.ini | grep -i 'Name' | cut -d '=' -f 2 | awk '{print tolower($0)}')

    echo "Making profile directories..."
    for profile in ${profileList}; do
        mkdir -p "${HOME}/.config/firefox/${profile}"
    done
}

applyPolicies() {
    echo "Copying policies.json (may need root permissions)..."

    if [[ -d /usr/lib/firefox ]]; then
        sudo ln -sf "${SCRIPT_PATH}"/policies.json /usr/lib/firefox/distribution
    elif [[ -d /opt/firefox-nightly ]]; then
        sudo chown -R ${USER}:${USER} /opt/firefox-nightly
        ln -sf "${SCRIPT_PATH}"/policies.json /opt/firefox-nightly/distribution
    elif [[ -d /opt/firefox-developer-edition ]]; then
        ln -sf "${SCRIPT_PATH}"/policies.json /opt/firefox-developer-edition/distribution
    elif [[ -d /opt/firefox-beta ]]; then
        ln -sf "${SCRIPT_PATH}"/policies.json /opt/firefox-beta/distribution
    elif [[ -d /usr/lib/firefox-developer-edition ]]; then
        sudo ln -sf "${SCRIPT_PATH}"/policies.json /usr/lib/firefox-developer-edition/distribution
    fi
}

cleanUp() {
    echo "Cleaning up after myself..."
    rm -rf "${SCRIPT_PATH}"/workdir
}

startFirefox() {
    $(command -v firefox) --ProfileManager 2> /dev/null || \
    $(command -v firefox-developer-edition) --ProfileManager 2> /dev/null || \
    $(command -v firefox-beta) --ProfileManager 2> /dev/null

    echo "Firefox is setup and started. Have a good day!"
}
