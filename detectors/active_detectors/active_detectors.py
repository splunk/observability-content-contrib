#!/usr/bin/env python3

# Usage: active_detectors.py -t <ACCESS_TOKEN> -r <REALM> -d <NO_OF_DAYS>
# 
# This script will fetch the events for detectors (max. 1,000) in an Org.
# 
# The output will show detectors with no events, detectors with events
# and how many events have fired within the number of days specified.

import argparse
import requests
import datetime
import time
import background
from rich.console import Console
from rich.table import Table
from rich.progress import track
import csv
background.n = 40

console = Console()
table = Table(show_header=True, title='Active Detector Report')

def days_elapsed(curr_time, timestamp):
    ml = curr_time - timestamp
    days = ml / 86400000
    return days

def link(url):
    return f'[blue][u]{url}[/u][/blue]'

def get_detectors(realm):
    detectors_dict = {}

    detectors = requests.get("https://api." + realm + ".signalfx.com/v2/detector?limit=10", headers=headers).json()
    #print(json.dumps(detectors))
    #print(str(detectors["count"]) + " detectors found!")

    for x in detectors["results"]:
        if x["creator"] != 'AAAAAAAAAAA':
            detectors_dict[x["id"]] = x["name"]

    find_events(detectors_dict)


@background.task
def find_events(detectors_dict):
    table.add_column('Detector ID')
    table.add_column('Detector Name')
    table.add_column('Total # Events', justify='right')
    table.add_column('# Events Triggered last ' + str(args["days"]) + ' days', justify='right')
    csv_header = ['Detector ID', 'Detector Name', 'Total # Events', 'Events Triggered last' + str(args["days"]) + ' days']
    with open('active_detectors.csv', 'w', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(csv_header)
        for k, v in track(detectors_dict.items(), 'Pulling Detector Events...'):
            ce = 0
            ct = 0
            
            events = requests.get("https://api." + args["realm"] + ".signalfx.com/v2/detector/" + k + "/events", headers=headers).json()
            for z in events:
                ce = ce + 1
                #print(datetime.datetime.fromtimestamp(z["timestamp"] / 1000))
                if days_elapsed(curr_epoch, z["timestamp"]) < args["days"]:
                    ct = ct + 1
            if ce == 0:
                table.add_row('[link=https://app.' + args["realm"] + '.signalfx.com/#/detector-wizard/' + k + '/edit]' + k + '[/link]', v, '[green]0', '[green]0')
                writer.writerow([k, v, '0', '0'])
            else:
                table.add_row("[yellow][link=https://app." + args["realm"] + ".signalfx.com/#/detector-wizard/" + k + "/edit]" + k + "[/link]", "[yellow]" + v, "[bold red]" + str(ce) + "[/bold red]", "[bold orange3]" + str(ct) + "[/bold orange3]")
                writer.writerow([k, v, ce, ct])
        console.print(table)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Splunk O11y Cloud - Active Detectors")
    parser.add_argument("-t", "--token", help="Access Token", required=True)
    parser.add_argument("-r", "--realm", help="us0, us1, us2, eu0 or jp0", required=True)
    parser.add_argument("-d", "--days", type=int, help="No. of days ago", required=True)
    args = vars(parser.parse_args())

    # Set O11y Cloud API headers
    headers = {
        "Content-Type": "application/json",
        "X-SF-TOKEN": args["token"],
    }

    t = time.time()
    curr_epoch = int(t * 1000)

    get_detectors(args["realm"])

