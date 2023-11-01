#!/bin/bash

# Define the path to the container
CONTAINER_PATH="volume1/docker"

# Define the appID and container name
APP_ID="556450"
CONTAINER_NAME="the-forest"

# Path to the appmanifest file
MANIFEST_PATH="/${CONTAINER_PATH}/${CONTAINER_NAME}/gamefiles/steamapps/appmanifest_${APP_ID}.acf"

# Extract the current build ID
CURRENT_BUILD_ID=$(grep buildid "$MANIFEST_PATH" | cut -d'"' -f4)
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to extract current build ID."
    exit 1
fi

# Get the latest build ID from the SteamCMD API
LATEST_BUILD_ID=$(curl -s -N -X GET "https://api.steamcmd.net/v1/info/${APP_ID}" | jq ".data.\"${APP_ID}\".depots.branches.public.buildid" | xargs printf '%d')
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to retrieve latest build ID."
    exit 1
fi

# Compare the build IDs and restart the Docker container if an update is available
if (( CURRENT_BUILD_ID < LATEST_BUILD_ID ))
then
    echo "${CONTAINER_NAME} update available. Restarting the container..."
    docker restart "${CONTAINER_NAME}"
else
    echo "No update available for ${CONTAINER_NAME}."
fi