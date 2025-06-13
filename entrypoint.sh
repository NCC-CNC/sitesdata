#!/bin/sh
# This script is executed when the container starts.

# The 'set -e' command ensures that the script will exit immediately if any command fails.
set -e

# Take ownership of the /opt/db directory.
# This is crucial because the volume is mounted at runtime from the host,
# and its permissions might not allow the 'shiny' user to write to it.
# We use 'sudo' because this script will run as root initially.
echo "Taking ownership of /opt/db..."
sudo chown -R shiny:shiny /opt/db

# Execute the command passed to this script (the CMD from the Dockerfile).
# The 'exec' command replaces the shell process with the new process,
# which is good practice for the main container process.
exec "$@"