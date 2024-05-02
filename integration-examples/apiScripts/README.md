# Contribution repository for Splunk Observability Content apiScripts

This repository exists to enable sharing of content.

This directory contains sample API Scripts that you can use to call the Splunk Observability Cloud API. 

# addEmailToDetectors.py
This script will allow users to insert an email address to the notifications for one or more detectors. It works with the token.yaml file which contains optional and required values needed to run the script. Please refer to the comments in the token.yaml file for more details.

# getMetricsForHost.py
This script is used to find all the metrics for a given host.

# muteAllAutoDetectors.py
This script will mute all auto-detectors. It can also be used to re-enable (unmute) all detectors. (NOTE: Unmuting won't distinguish those you muted with the script or muted manually.)