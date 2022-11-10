# SC4SNMP (Splunk Connect for SNMP) Dashboard

This folder contains a dashboard, `SNMP Agents` (WIP), to get insights out of [SC4SNMP](https://splunk.github.io/splunk-connect-for-snmp/main) metrics. This dashboard was built for `snmpd` running on Linux. Metric names may be different for other devices, which would require the dashboard to be updated.

There is also a dashboard group, `Network Devices (SNMP)`, which provides basic device, interface and protocol metrics
for devices based on the MIB-2 metrics (which should be available in basically any network device). This dashboard group is
recommended as an initial dashboard for edge network device monitoring.

## Setup

This dashboard requires [SC4SNMP](https://splunk.github.io/splunk-connect-for-snmp/main) to be set up:

- [SC4SNMP official documentation](https://splunk.github.io/splunk-connect-for-snmp/main)
- [Walkthrough of SC4SNMP setup with Linux agents running `snpmd`](https://smathur-splunk.github.io/workshops/snmp_intro)

Follow these links to set up and configure SC4SNMP to send data to O11y Cloud. Set up SNMP agents as described in the second link and configure them for polling by SC4SNMP.

The dashboard should automatically populate, but metric names may need changing as they may vary from agent to agent.
