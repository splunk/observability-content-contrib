#!/usr/bin/env bash

# --- Set default value for REALM if not already set ---
# This uses bash parameter expansion:
# ${parameter:-word} If parameter is unset or null, the expansion of word is substituted.
# Otherwise, the value of parameter is substituted.
REALM="${REALM:-eu1}"
echo "REALM is set to: $REALM" >&2 # Redirect to stderr

# --- Function to check if an environment variable is set ---
# This makes the checks more concise and reusable.
check_env_var() {
  local var_name="$1"
  if [[ -z "${!var_name}" ]]; then # ${!var_name} is indirect expansion to get the value of the variable named by var_name
    echo "Error: The environment variable $var_name is not set. Please set it before running this script." >&2
    exit 1 # Exit with a non-zero status to indicate an error
  fi
  echo "$var_name is set." >&2 # Redirect to stderr
}

# --- Check required environment variables ---
check_env_var "TOKEN"
check_env_var "APP"
check_env_var "ENVIRONMENT"

CURRENT_TIMESTAMP_MILLIS=$(($(date +%s) * 1000 + $(date +%N | cut -b1-3)))
echo "Script continues with REALM=$REALM, APP=$APP, ENVIRONMENT=$ENVIRONMENT (TOKEN value hidden)." >&2 # Redirect to stderr


curl -s 'https://app.'${REALM}'.signalfx.com/v2/rum/graphql?op=RumNodeMetricsAggregatedQuery1' \
-X 'POST' \
-H 'Content-Type: application/json' \
-H 'Sec-Fetch-Dest: empty' \
-H 'Accept: */*' \
-H 'Sec-Fetch-Site: same-origin' \
-H 'Accept-Language: nl-NL,nl;q=0.9' \
-H 'Accept-Encoding: gzip, deflate, br' \
-H 'Sec-Fetch-Mode: cors' \
-H 'x-sf-token: '${TOKEN}'' \
-H 'Priority: u=3, i' \
--data-raw '{"operationName":"RumNodeMetricsAggregatedQuery1","variables":{"useAlternate":false,"endTimeMillis":'${CURRENT_TIMESTAMP_MILLIS}',"lookbackMillis":691200000,"resolutionMillis":7200000,"metricFamilyAggregations":{"metricFamilyName":"page_view","aggregations":["COUNT"],"orderByAggregation":"COUNT"},"limit":100,"filters":[{"type":"contains","scope":"GLOBAL","tag":"sf_product","values":["web"]},{"type":"contains","scope":"GLOBAL","tag":"app","values":["'${APP}'"]},{"type":"contains","scope":"GLOBAL","tag":"sf_environment","values":["'${ENVIRONMENT}'"]}],"dimension":"sf_node_name","includeNulls":true},"query":"query RumNodeMetricsAggregatedQuery1($endTimeMillis: Float, $lookbackMillis: Float, $resolutionMillis: Float, $dimension: String, $metricFamilyAggregations: MetricFamilyAggregationsInput!, $limit: Int, $includeNulls: Boolean, $filters: [Filter!], $useAlternate: Boolean, $skipTimeseries: Boolean) {\n  rumNodeMetricsV3(\n    endTimeMillis: $endTimeMillis\n    lookbackMillis: $lookbackMillis\n    resolutionMillis: $resolutionMillis\n    dimension: $dimension\n    metricFamilyAggregations: $metricFamilyAggregations\n    limit: $limit\n    includeNulls: $includeNulls\n    filters: $filters\n    useAlternate: $useAlternate\n    skipTimeseries: $skipTimeseries\n  ) {\n    nodes {\n      nodeName\n      metrics {\n        metricFamilyName\n        aggregation\n        total\n        timeseries\n        __typename\n      }\n      __typename\n    }\n    __typename\n  }\n}\n"}' | gunzip | jq -r '.data.rumNodeMetricsV3.nodes[].nodeName' | sort
