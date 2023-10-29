
# SteamCMD Update Check To Restart Container

## Use
This script is to be used as a User Script on a Synology NAS with the [SteamCMD containers from ich777](https://github.com/ich777/docker-steamcmd-server) to check the current build ID derived from the app manifest file of the installed application exposed via the volume(s) from the container against the build ID online from SteamCMD.

## Installation

- Make sure that the `appmanifest_${APP_ID}.acf` file is accessible from the Synology command line for example it is stored on a volume on the file system outside of the container.
- You will need the App/Game ID (this can be found within the container environmental variables), path to the container volume minus leading and trailing slash (e.g. volume1/docker), and container name (this is whatever the container is named in container manager).
- Copy the script from `steamcmd-update-check-restart-container.sh` or make a fork and edit in an editor to update the `CONTAINER_PATH`, `APP_ID`, and `CONTAINER_NAME` to the needed values and copy the script.
- On the Synology in the Task Scheduler create a new Schedculed Task > User-defined script and give it a name setting User to root.
- On the Schedule tab set as needed (e.g. Daily, Start time: 1:00, Repeat every hour).
- On the Task Settings tab paste the copied script into the User-defined script window and update the `CONTAINER_PATH`, `APP_ID`, and `CONTAINER_NAME` to the needed values directly or paste the script previously edited.
- Click ok and enter the admin password to finalize the user script.

## Notes

- Logging may be enabled under Settings of the Task Scheduler.