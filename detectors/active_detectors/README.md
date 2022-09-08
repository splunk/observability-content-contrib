# Active Detector Report

This script will fetch the events for detectors (max. 1,000) in an Org.

The output will show detectors with no events, detectors with events and how many events have fired within the number of days specified on the command line.

The table supports hyperlinks on the detector ID if your terminal supports it.

Also, a CSV report will be created in the same directory as you run the script.

## Using the Active Detector Report script

![Active Detectors Report](./images/screenshot.png)

1. Install the required packages with `pip3 installl -r requirements.txt`
2. Obtain an Org Access Token (with API permissions) and note the Realm your Org is in e.g. us1, eu0, jp0 etc.
3. Run the script e.g. `python3 active_detectors -t <ACCESS_TOKEN -r <REALM> -d <NO_OF_DAYS>`

### Full CLI options

``` bash
$ python3 active_detectors.py -h

usage: active_detectors.py [-h] -t TOKEN -r REALM -d DAYS

Splunk O11y Cloud - Active Detectors

options:
  -h, --help            show this help message and exit
  -t TOKEN, --token TOKEN
                        Access Token
  -r REALM, --realm REALM
                        us0, us1, us2, eu0 or jp0
  -d DAYS, --days DAYS  No. of days ago
```
