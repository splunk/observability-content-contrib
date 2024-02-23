#!/usr/bin/env python
#
# This script will add an email notification to all detectors for an org as specifified by the emailAddress variable. 
#
# Edit token.yaml for valid Access Token, Realm, Email Address, etc.
#
# Syntax: python3 addEmailToDetectors.py

import yaml
import json
import asyncio
import aiohttp

token = ''
realm = ''
headers = ''
emailAddress = ''
limit = 50
offset = 0

# get the detector(s) from Splunk Observability Cloud
async def fetch_get(url):
    try:
      async with aiohttp.ClientSession(headers=headers) as session:
        async with session.get(url) as response:
          return await response.json()
    except Exception as e:
      print(f'Exception {e}') 
      return "error"

# async reposting updated detectors back to Splunk Observability Cloud
async def post_url(session, url, payload):
    async with session.put(url, data=json.dumps(payload), headers=headers) as response:
        return await response.text()


async def main():
  if token is None or realm is None or emailAddress is None:
   print("A User API Access Token, Realm and Email Address is required.")
   return
  
  # get either a list of detectors or a specific detector if detectorName was passed in the arguments
  url = f"https://api.{realm}.signalfx.com/v2/detector?limit={limit}&offset={offset}" 
  if(detectorName is not None):
    url = url + f"&name={detectorName}"

  #get the detector(s) asynchronously
  get_response = await fetch_get(url)
  if get_response == "error":
    return

  #create an array for printing results
  updatedDetectors = {}
  for results in get_response['results']:
    id = results['id']
    try:
      toAdd = { 'type': 'Email', 'email': f'{emailAddress}' }
      #iterate through the results, adding an email notification to each
      i = 0
      for rule in results["rules"]:
        results["rules"][i]["notifications"].append(toAdd)
        i += 1
      updatedDetectors[f"https://api.{realm}.signalfx.com/v2/detector/{id}"] = results

    except Exception as e:
       print(f'Exception for id {id}: {e}')
  
  payload = ''
  # now send the post   
  async with aiohttp.ClientSession() as session:
    tasks = [post_url(session, url, payload) for url, payload in updatedDetectors.items()]
    results = await asyncio.gather(*tasks)

  #uncomment to print out response results
  #for url, result in zip(updatedDetectors, results):
  #  print(f"Response from {url}: {result}")

# entry point
if __name__ == '__main__':

  with open('token.yaml', 'r') as ymlfile:
    cfg = yaml.safe_load(ymlfile)

  token = cfg['access_token'] 
  realm = cfg['realm'] 
  emailAddress = cfg['emailAddress'] 
  detectorName = cfg['detectorName'] 
  if cfg['limit']:
    limit = cfg['limit']

  if cfg['offset']:
    offset = cfg['offset']

  headers = {"Content-Type": "application/json", "X-SF-TOKEN": f"{token}" }
  asyncio.run(main())