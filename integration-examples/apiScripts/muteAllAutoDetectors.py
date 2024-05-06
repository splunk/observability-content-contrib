#!/usr/bin/env python
#
# This script will mute all auto-detectors. 
#
# Edit token.yaml to contain valid
# - Access Token (access_token)
# - Realm (realm) 
#
# Syntax: python3 muteAllAutoDetectors.py
#         to disable all auto detectors
#
#         python3 muteAllAutoDetectors.py -e
#         to re-enable all auto detectors

import argparse
import yaml
import requests
import json

def muteDetectors(realm, token, enableDisable, responseJSON):
  arrDetectors = []
  for result in responseJSON['results']:
    id = result['id']
    name = result['name']
    type = result['detectorOrigin']
    if type == "AutoDetect":
      url = f"https://api.{realm}.signalfx.com/v2/detector/{id}/{enableDisable}"
      headers = {"Content-Type": "application/json", "X-SF-TOKEN": f"{token}" }
      response = requests.put(url, headers=headers)
      if response.status_code == 204:
        print(f"SUCCESS: {name} muting {enableDisable}d.")
        arrDetectors.append(name)
      else:
        print(f"ERROR: {name} muting change failed.")
  return arrDetectors

def callAPI(realm, token, bDisable):
  arrDetectors = []
  limit = 10000
  offset = 0

  if bDisable:
    enableDisable = "disable"
  else:
    enableDisable = "enable"

  url = f"https://api.{realm}.signalfx.com/v2/detector?limit={limit}"
  headers = {"Content-Type": "application/json", "X-SF-TOKEN": f"{token}" }
  response = requests.get(url, headers=headers)
  responseJSON = json.loads(response.text)
  try:
    cnt = responseJSON["count"]
  except:
    print("ERROR: Check your token, that's the most likely issue.")
    print(response.text)
    return

  if (cnt > 10000):
    print(f'You have more than 10,000 detectors ({cnt} found).')
    print('Presenting the results for the first 10,000.')
    #break

  arrDetectors = muteDetectors(realm, token, enableDisable, responseJSON)
  #print(arrDetectors)

if __name__ == '__main__':
  with open('token.yaml', 'r') as ymlfile:
    cfg = yaml.safe_load(ymlfile)
  
  parser = argparse.ArgumentParser(description='Splunk - Mute All Auto-Detectors')
  parser.add_argument('-r', '--realm', help='Realm', required=False)
  parser.add_argument('-t', '--token', help='Token', required=False)
  parser.add_argument('-e', '--enable', action=argparse.BooleanOptionalAction)
  args = parser.parse_args()
  
  bDisable = True
  if args.enable is not None:
    bDisable = False

  realm = cfg['realm'] if args.realm is None else args.realm
  token = cfg['access_token'] if args.token is None else args.token

  callAPI(realm, token, bDisable)
