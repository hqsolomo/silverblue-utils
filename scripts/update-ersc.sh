#!/bin/bash

# TODO: detect when base ER and ERSC are mismatched and ask user if they'd like to update ERSC

GAME_DIR="${1:-"~/Games/SteamLibrary/steamapps/common/ELDEN RING/Game/"}"
ERSC_DOWNLOAD_URL="https://github.com/LukeYui/EldenRingSeamlessCoopRelease/releases/download/"
ERSC_VER="${2:-"v1.8.1"}" # TODO either get specific version mentioned by error OR get latest version from repo, whichever is easier than manually specifying at cli. Either way, call function to autofill needed version if none specified at cli
ERSC_NAME="ersc_${ERSC_VER}" # TODO there's gotta be a better way to do this part
ERSC_DIR="SeamlessCoop"
ERSC_CONFIG="ersc_settings.ini"
RUN_TIMESTAMP="$(date +%Y%m%d%s)"

# 1=GAME_DIR
# 2=ERSC_DIR
# 3=RUN_TIMESTAMP
backup_ersc(){
    cp -pr "$1""$2" "$1""$2""$3"
}

# 1=GAME_DIR
# 2=ERSC_DOWNLOAD_URL
# 3=ERSC_VER
# 4=ERSC_NAME
download_ersc(){
    wget -P "$1" "$2""$3"/"$4".zip
}

# 1=GAME_DIR
# 2=ERSC_NAME
# 3=ERSC_DIR
# 4=RUN_TIMESTAMP
# 5=ERSC_CONFIG
install_ersc(){
    unzip "$1""$2".zip "$3"/* -d "$1"
    cp -pr "$1""$3""$4"/"$5" "$1""$3"/"$5"
}

# 1=GAME_DIR
# 2=ERSC_NAME
cleanup(){
    rm -f "$1""$2".zip
}

main(){
    backup_ersc "$GAME_DIR" "$ERSC_DIR" "$RUN_TIMESTAMP"
    download_ersc "$GAME_DIR" "$ERSC_DOWNLOAD_URL" "$ERSC_VER" "$ERSC_NAME"
    install_ersc "$GAME_DIR" "$ERSC_NAME" "$ERSC_DIR" "$RUN_TIMESTAMP" "$ERSC_CONFIG"
    cleanup "$GAME_DIR" "$ERSC_NAME"
}
