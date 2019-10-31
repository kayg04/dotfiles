#!/usr/bin/env bash
# import sanity
set -euo pipefail

# global declarations
SCRIPT_PATH=$(dirname $(realpath "$0"))
URL="https://github.com/dasJ/spotifywm.git"

fetchSource() {
    echo -e "Fetching source..."
    if git clone --quiet "${URL}" "${SCRIPT_PATH}"/spotifywm; then
        echo -e "\t-> Source fetched successfully."
    else
        echo -e "\t-> Source couldn't be fetched."
    fi
}

buildLibrary() {
    cd "${SCRIPT_PATH}/spotifywm"

    echo -e "Building library..."
    if make -j$(nproc); then
        echo -e "\t-> Library built successfully."
    else
        echo -e "\t-> Library building failed."
    fi

}

moveLibrary() {
   echo -e "Moving built library to /usr/lib (need root permissions)..."
   sudo mv "${SCRIPT_PATH}/spotifywm/spotifywm.so" /usr/lib
}

fixSpotify() {
    cp /usr/share/applications/spotify.desktop "${HOME}"/.local/share/applications
    sed -Ein 's/^Exec=(.*)/Exec=LD_PRELOAD=\/usr\/lib\/spotifywm.so \1/g' "${HOME}"/.local/share/applications/spotify.desktop
}
