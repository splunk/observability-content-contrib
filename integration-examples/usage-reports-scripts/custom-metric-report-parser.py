#!/usr/bin/env python3

import argparse
import csv
from rich.console import Console
from rich.table import Table

parser = argparse.ArgumentParser(
    description="Splunk Observability Cloud - Custom Metrics Report Parser"
)
parser.add_argument(
    "-c",
    "--category",
    help="1 (Host), 2 (Container), 3 (Custom), 4 (Hi-Res), 5 (Bundled)",
    default="3",
)
parser.add_argument(
    "-l", "--limit", help="Limit no. of metrics displayed in table", default=10000
)
parser.add_argument("-r", "--report", help="Custom Metric Report", required=True)
args = vars(parser.parse_args())

if args["category"] == "1":
    type = "No. Host MTS"
elif args["category"] == "2":
    type = "No. Container MTS"
elif args["category"] == "3":
    type = "No. Custom MTS"
elif args["category"] == "4":
    type = "No. High Resolution MTS"
elif args["category"] == "5":
    type = "No. Bundled MTS"

console = Console()

metrics_list = {}

table = Table(
    title="Splunk - Custom Metrics Report Parser",
    style="bright_magenta",
    title_style="bold italic",
)

table.add_column("Metric Name", justify="left", style="cyan", no_wrap=True, width=80)
table.add_column("MTS", justify="right", style="green")


with open(args["report"]) as f:
    reader = csv.DictReader(f, delimiter="\t")
    for row in reader:
        if int(row[type]) != 0:
            metrics_list[row["Metric Name"]] = int(row[type])

total = 0

res = sorted(metrics_list.items(), key=lambda v: v[1], reverse=True)
for r in res[: int(args["limit"])]:
    mts = "{:,}".format(r[1])
    table.add_row(r[0], mts)
    total = total + int(r[1])

total = "{:,}".format(total)
table.add_row("Total MTS", total, style="bold white", end_section=True)
console.print(table)
