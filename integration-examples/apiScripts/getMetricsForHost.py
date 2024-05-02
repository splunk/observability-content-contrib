#!/usr/bin/env python
#
# This script will get all unique metrics for a given host. 
#
# Edit token.yaml to contain valid
# - Access Token (access_token)
# - Realm (realm)
#
# Syntax: python3 getMetricsForHost.py -h <HOST_NAME>
# or
#         python3 getMetricsForHost.py -h <HOST_NAME> -r <realm> -t <token>
#
# HOST_NAME should be an exact match

import argparse
import yaml
import requests
import json

def run(hostname, realm, token):
  limit = 5000
  url = "https://api.{}.signalfx.com/v2/metrictimeseries?limit={}&query=host.name:{}".format(realm, limit, hostname)
  headers = {"Content-Type": "application/json", "X-SF-TOKEN": "{}".format(token) }
  response = requests.get(url, headers=headers)
  responseJSON = json.loads(response.text)
  
  # If the result count is > limit, say so and exit
  try:
    cnt = responseJSON["count"]
  except:
    print("ERROR: Check your token, that's the most likely issue.")
    return

  if (cnt == 0):
    # Let's try using host instead of host.name (SmartAgent)
    print("--> No results for host.name, trying host")
    url = "https://api.{}.signalfx.com/v2/metrictimeseries?limit={}&query=host:{}".format(realm, limit, hostname)
    response = requests.get(url, headers=headers)
    responseJSON = json.loads(response.text)
    try:
      cnt = responseJSON["count"]
    except:
      print("ERROR: Unusual to fail here, probably an issue with the script.")
      return

  if (cnt > limit):
    print("Need to increase limit, this host has > {} mts's.".format(limit))
    return    

  # Add metrics to a list
  arr = []
  for result in responseJSON['results']:
    arr.append(result['metric'])

  totalCount = len(arr)
  arr = list(set(arr)) # Remove Duplicates
  arr.sort()
  print(*arr, sep = "\n") # Print one per line
  print("--> {} metrics; {} mts".format(len(arr), totalCount))

if __name__ == '__main__':
  with open('token.yaml', 'r') as ymlfile:
    cfg = yaml.safe_load(ymlfile)
  
  parser = argparse.ArgumentParser(description='Splunk - Get Host Metrics')
  parser.add_argument('-n', '--hostName', help='HostName', required=True)
  parser.add_argument('-r', '--realm', help='Realm', required=False)
  parser.add_argument('-t', '--token', help='Token', required=False)
  args = parser.parse_args()

  if (args.token is None):
    run(args.hostName, cfg['realm'], cfg['access_token'])
  else:
    run(args.hostName, args.realm, args.token)
