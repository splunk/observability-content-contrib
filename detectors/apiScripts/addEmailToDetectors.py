#!/usr/bin/env python
#
# This script will add an email notification to all detectors for an org as specifified by the emailAddress variable. 
#
# Edit token.yaml.sample to contain valid Access Token and Realm rename to token.yaml
#
# Syntax: python3 addEmailToDetectors.py

import argparse
import yaml
import requests
import json

token = ''
realm = ''
headers = ''
emailAddress = 'ENTER-VALID-EMAIL-HERE'

#gets list of detectors for the org
def getDetectors(responseJSON, arrDetectors):
  for results in responseJSON['results']:
    tmpId = results['id']
    try:
      updateDetector(tmpId)
      arrDetectors.append(tmpId)
    except Exception as e:
      print(f'Exception for id {id}: {e}')

  return arrDetectors

#update the detector
def updateDetector(id):
    try:
      
      # get the detector
      url = f"https://api.{realm}.signalfx.com/v2/detector/{id}"
      response = requests.get(url, headers=headers)
      responseJSON = json.loads(response.text)
      toAdd = { 'type': 'Email', 'email': f'{emailAddress}' }

      i =0
      for rule in response.json()["rules"]:
        responseJSON["rules"][i]["notifications"].append(toAdd)
        i = i+1
      url = f"https://api.{realm}.signalfx.com/v2/detector/{id}"
      response = requests.put(url, headers=headers, json=responseJSON) 

      if response.status_code == 200:
        print("updated id {id}")
      else:
        print("ERROR: could not update id {id}")

    except Exception as e:
      print(f'Exception {e}')

def callAPI():
  arrDetectors = []
  limit = 10000
  offset = 0

  url = f"https://api.{realm}.signalfx.com/v2/detector"
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
    print('You will need to do this with getMetricMetadataFromReport.py.')
    print('Presneting the results for the first 10,000.')
    #break

  arrDetectors = getDetectors(responseJSON, arrDetectors)
  print('updated the following detectors: {arrDetectors}')

if __name__ == '__main__':
  with open('token.yaml', 'r') as ymlfile:
    cfg = yaml.safe_load(ymlfile)
  
  parser = argparse.ArgumentParser(description='Splunk - Get Recent Detectors')
  parser.add_argument('-r', '--realm', help='Realm', required=False)
  parser.add_argument('-t', '--token', help='Token', required=False)
  args = parser.parse_args()

  token = cfg['access_token'] if args.token is None else args.token
  realm = cfg['realm'] if args.realm is None else args.realm
  headers = {"Content-Type": "application/json", "X-SF-TOKEN": f"{token}" }
  callAPI()