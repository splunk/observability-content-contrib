#!/bin/bash

# on error, run away, exit, don't continue, etc... 
set -e

# output a script to the file system so it can be executed later... 
cat <<EOF >>/tmp/splunk/otel-script.sh
#!/bin/bash
set -e

if [ \$DB_IS_DRIVER ]; then 
	# Set default environment variables for the installation scripts to use. ##
	# 1. splunkObservability.realm=<us0|us1|eu1|jp0|future_realm>
	# 2. splunkObservability.accessToken=<Splunk Observability Cloud Ingest Token>
	# 3. clusterName=<my-local-otel-collector-cluster|an-actual-useful-name>
	# OTEL Service Information ##
	# OTEL_SERVICE_NAME = "Splunk-Databricks-OTEL"
	# OTEL_TRACES_EXPORTER = "jaeger-thrift-splunk"
	# OTEL_EXPORTER_JAEGER_ENDPOINT = "https://ingest.<realm>.signalfx.com/v2/trace"

	# Validate Secrets: Check to see if there is a secret in the secret store before executing the script to install the OpenTelemetry Collector.
	echo "Running OpenTelemetry collector installation script"
	echo "Pre-Installation: Validation: Secret Key(s)" 
	echo "SPLUNK_ACCESS_TOKEN must be stored in the Databricks "

	if [ -z "\$SPLUNK_ACCESS_TOKEN" ]; then 
		echo 'Please set the secret for the SPLUNK_ACCESS_TOKEN in the databricks environment secret store.'
		exit 1; 
	fi

	# Validation of parameters installation of the Splunk OpenTelemetry Collector Script
	echo "Pre-Installation: Validation environmental parameters"
	echo "SPLUNK_REALM: us0 (default), Actual: "\$SPLUNK_REALM
	echo "SPLUNK_MEMORY_TOTAL_MIB: 512 MIB (default), Actual: "\$SPLUNK_MEMORY_TOTAL_MIB

	SPLUNK_ACCESS_TOKEN="\$SPLUNK_ACCESS_TOKEN" bash -c "\$(curl -sSL https://dl.signalfx.com/splunk-otel-collector.sh > /tmp/splunk-otel-collector.sh;)"
	SPLUNK_ACCESS_TOKEN="\$SPLUNK_ACCESS_TOKEN" bash -c "\$(sudo sh /tmp/splunk-otel-collector.sh --realm \$SPLUNK_REALM --memory \$SPLUNK_MEMORY_TOTAL_MIB \
	-- \$SPLUNK_ACCESS_TOKEN)"
EOF

# Determine where the script is being executed: 
# if: Driver: do driver stuff, else if Worker: do worker stuff, else Driver and Worker: do stuff
echo $DB_IS_DRIVER
if [[ $DB_IS_DRIVER = "TRUE" ]]; then
# Logic for the Driver would go here ##

else
# Logic for the Worker would go here ##
fi
# Shared Logic for the Driver and Worker ##

  # Modify the permissions of the script so it can be executed. 
  chmod a+x /tmp/splunk/otel-script.sh
  # Run the installation script and output logs to: /tmp/splunk/otel-script.log
  /tmp/splunk/otel-script.sh >> /tmp/splunk/otel-script.log 2>&1 & disown