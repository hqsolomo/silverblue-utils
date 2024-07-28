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

if backup_ersc "$GAME_DIR" "$ERSC_DIR" "$RUN_TIMESTAMP"
then
    if ! download_ersc "$GAME_DIR" "$ERSC_DOWNLOAD_URL" "$ERSC_VER" "$ERSC_NAME"; then logger "There was an error downloading ERSC version $ERSC_VER from $ERSC_DOWNLOAD_URL$ERSC_VER/ersc.zip. Aborting $BASENAME."; exit 1; fi
    if ! install_ersc "$GAME_DIR" "$ERSC_NAME" "$ERSC_DIR" "$RUN_TIMESTAMP" "$ERSC_CONFIG"; then logger "ERSC updates have been downloaded to $GAME_DIR but there was an error installing ERSC updates. Please check $GAME_DIR for artifacts and/or to manually complete updates. Aborting $BASENAME."; exit 2; fi
    if ! cleanup "$GAME_DIR" "$ERSC_NAME"; then logger "Could not cleanup update artifacts from $GAME_DIR. Please manually remove $GAME_DIR$ERSC_NAME.zip."; fi
else
    logger "Could not back up $GAME_DIR$ERSC_DIR. Aborting $BASENAME."
fi
logger "$BASENAME has updated ERSC to version $ERSC_VER. May grace guide you, o tarnished!"
