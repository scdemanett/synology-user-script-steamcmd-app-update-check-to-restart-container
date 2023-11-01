#!/bin/bash

# Define the path to the container
CONTAINER_PATH="volume1/docker"

# Define the array of appIDs and container name
APP_IDS=("228980" "728470") # Replace with actual APP_IDs
CONTAINER_NAME="astroneer"

# Initialize a variable to determine if a restart is needed
RESTART_NEEDED=0

# Loop through each APP_ID and its corresponding MANIFEST_PATH
for APP_ID in "${APP_IDS[@]}"; do
    MANIFEST_PATH="/${CONTAINER_PATH}/${CONTAINER_NAME}/gamefiles/steamapps/appmanifest_${APP_ID}.acf"

    # Extract the current build ID
    CURRENT_BUILD_ID=$(grep buildid "$MANIFEST_PATH" | cut -d'"' -f4)
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to extract current build ID for APP_ID ${APP_ID}."
        continue
    fi

    # Get the latest build ID from the SteamCMD API
    LATEST_BUILD_ID=$(curl -s -N -X GET "https://api.steamcmd.net/v1/info/${APP_ID}" | jq ".data.\"${APP_ID}\".depots.branches.public.buildid" | xargs printf '%d')
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to retrieve latest build ID for APP_ID ${APP_ID}."
        continue
    fi

    # Compare the build IDs and set the restart flag if an update is available
    if (( CURRENT_BUILD_ID < LATEST_BUILD_ID )); then
        echo "Update available for ${CONTAINER_NAME} for APP_ID ${APP_ID}."
        RESTART_NEEDED=1
    else
        echo "No update available for ${CONTAINER_NAME} for APP_ID ${APP_ID}."
    fi
done

# Restart the Docker container if an update is available
if (( RESTART_NEEDED == 1 )); then
    echo "Updates were found. Restarting the container ${CONTAINER_NAME}..."
    docker restart "${CONTAINER_NAME}"
else
    echo "No updates were found. No need to restart the container."
fi