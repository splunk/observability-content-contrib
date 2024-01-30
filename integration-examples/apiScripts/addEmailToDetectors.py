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
emailAddress = ''

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
      #iterate through the results, adding an email notification to each
      i =0
      for rule in response.json()["rules"]:
        responseJSON["rules"][i]["notifications"].append(toAdd)
        i = i+1
      url = f"https://api.{realm}.signalfx.com/v2/detector/{id}"
      response = requests.put(url, headers=headers, json=responseJSON) 

      if response.status_code == 200:
        print(f"updated id {id}")
      else:
        print(f"ERROR: could not update id {id}")

    except Exception as e:
      print(f'Exception {e}')

def callAPI(detectorName, limit, offset):
  arrDetectors = []
  # get either a list of detectors or a specific detector if detectorName was passed in the arguments
  url = f"https://api.{realm}.signalfx.com/v2/detector?limit={limit}&offset={offset}" 
  if(detectorName is not None):
    url = url + f"&name={detectorName}"

  response = requests.get(url, headers=headers)
  if(response.status_code==404):
    print("Detector not found")
    return
  if(response.status_code==401):
    print("ERROR: You are not authorized to call the API. Please check that you are using your user API token.")
    return

  responseJSON = json.loads(response.text)
  arrDetectors = getDetectors(responseJSON, arrDetectors)
  print(f'updated the following detectors: {arrDetectors}')

if __name__ == '__main__':
  with open('token.yaml', 'r') as ymlfile:
    cfg = yaml.safe_load(ymlfile)
  
  parser = argparse.ArgumentParser(description='Splunk - Add Email to Detectors')
  parser.add_argument('-e', '--emailAddress', help='email address', required=True)
  parser.add_argument('-r', '--realm', help='Realm', required=False, default='us1')
  parser.add_argument('-t', '--token', help='Token', required=False)
  parser.add_argument('-d', '--detectorName', help='Name of detector, else all detectors will get updated', required=False)
  parser.add_argument('-l', '--limit', help='Number of results to return from the list of detectors that match your search criteria.', required=False, default=50)
  parser.add_argument('-o', '--offset', help='Index, in the list of detectors that match your search criteria, at which you want to start downloading results.', required=False, default=0)
  args = parser.parse_args()

  token = cfg['access_token'] if args.token is None else args.token
  realm = cfg['realm'] if args.realm is None else args.realm
  emailAddress = args.emailAddress
  detectorName = args.detectorName
  limit = args.limit
  offset = args.offset

  headers = {"Content-Type": "application/json", "X-SF-TOKEN": f"{token}" }
  callAPI(detectorName, limit, offset)