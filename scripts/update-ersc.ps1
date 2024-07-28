### AUTHOR'S WARNING ###
# This was translated into Powershell by a Dolphin-Mixtral based 47B LLM and only glanced at by the original code's author. The original code was written in bash 4. When he has a break from *nix administration he will get around to cleaning this up.

# Feel free to reach out for a PR if you want to take a stab at it in the meantime.


# TODO: detect when base ER and ERSC are mismatched and ask user if they'd like to update ERSC

$BASENAME = Split-Path -leaf $MyInvocation.MyCommand.Definition
# GAME_DIR needs to be the location where Elden Ring is installed on your system
$GAME_DIR = "$HOME/Games/SteamLibrary/steamapps/common/ELDEN RING/Game/"

# TODO either get specific version mentioned by error OR get latest version from repo, whichever is easier than manually specifying at cli. Either way, call function to autofill needed version if none specified at cli

# ERSC_VER is the version of the Seamless Coop mod you're updating to
$ERSC_VER = "v1.8.1"
$ERSC_DOWNLOAD_URL = "https://github.com/LukeYui/EldenRingSeamlessCoopRelease/releases/download/"

# TODO there's gotta be a better way to do this part

$ERSC_NAME = "ersc_${ERSC_VER}"
$ERSC_DIR = "SeamlessCoop"
$ERSC_CONFIG = "ersc_settings.ini"
$RUN_TIMESTAMP = Get-Date -Format yyyyMMddHHmmss

function backup_ersc($game_dir, $er_dir, $run_timestamp) {
    Copy-Item "$game_dir\$er_dir" "${game_dir}\$er_dir`_${run_timestamp}" -Force -Recurse
}

function download_ersc($game_dir, $ersc_download_url, $ersc_ver, $ersc_name) {
    Invoke-WebRequest -Uri "$ersc_download_url$ersc_ver/$ersc_name.zip" -OutFile "$game_dir\$ersc_name.zip"
}

function install_ersc($game_dir, $ersc_name, $er_dir, $run_timestamp, $ersc_config) {
    Expand-Archive -Path "$game_dir\$ersc_name.zip" -DestinationPath "$game_dir" -Force
    Copy-Item "$game_dir\$er_dir`_${run_timestamp}\$ersc_config" "$game_dir\$er_dir\$ersc_config" -Force
}

function cleanup($game_dir, $ersc_name) {
    Remove-Item "$game_dir\$ersc_name.zip" -Force
}

Write-Output "Starting Elden Ring Seamless Coop update process."
Write-Output "Backing up current ERSC directory."
if (backup_ersc $GAME_DIR $ERSC_DIR $RUN_TIMESTAMP) {
    Write-Output "Current ERSC directory backed up to ${GAME_DIR}${ERSC_DIR}_${RUN_TIMESTAMP}."
    Write-Output "Downloading ERSC updates from ${ERSC_DOWNLOAD_URL}${ERSC_VER}/$ersc_name.zip."
    if (! (download_ersc $GAME_DIR $ERSC_DOWNLOAD_URL $ERSC_VER $ERSC_NAME)) {
        Write-Output "ERSC updates have been downloaded to ${GAME_DIR} but there was an error installing ERSC updates. Please check ${GAME_DIR} for artifacts and/or to manually complete updates. Aborting ${BASENAME}."
        exit 2
    }
    Write-Output "Successfully installed ERSC updates."
    Write-Output "Performing cleanup tasks."
    if (! (cleanup $GAME_DIR $ERSC_NAME)) {
        Write-Output "Could not cleanup update artifacts from ${GAME_DIR}. Please manually remove ${GAME_DIR}${ERSC_NAME}.zip."
    }
    Write-Output "Cleanup tasks completed."
} else {
    Write-Output "Could not back up ${GAME_DIR}${ERSC_DIR}. Aborting ${BASENAME}."
}
Write-Output "Updated ERSC to version ${ERSC_VER}. May grace of gold guide you, fellow tarnished!"
