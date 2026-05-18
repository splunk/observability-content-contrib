#!/usr/bin/env bash
# check_splunk_metric.sh
#
# Query Splunk Observability (SignalFx) timeserieswindow API and evaluate the latest
# data point of each returned MTS against a threshold criterion.
#
# Exit codes:
#   0 -> Criterion met (per request).
#   1 -> Criterion NOT met.
#   2 -> Error (HTTP/parse/usage).
#
# Requirements:
#   - bash
#   - curl
#   - jq
#
# Example:
#   ./check_splunk_metric.sh -r us0 -t "$X_SF_TOKEN" \
#     -q 'sf_metric:demo.trans.latency' -o gt -v 200 --scope any
#
# Meaning:
#   - If ANY latest value > 200, exit 1 (criterion met).
#   - If NONE > 200, exit 0 (criterion NOT met).
#
# Notes:
#   - The query should be provided in plain text; it will be URL-encoded by the script.
#   - Scope can be "any" (default) or "all".
#   - Operators: gt, ge, lt, le, eq, ne.

set -u

print_usage() {
  cat <<'USAGE'
Usage:
  check_splunk_metric.sh -r REALM -t TOKEN [-q QUERY] [-o OP] [-v THRESHOLD] [--scope any|all]

Required:
  -r, --realm        API realm, e.g., us0, eu0.
  -t, --token        X-SF-Token.

Optional:
  -q, --query        SignalFx search query (plain text). Default: sf_metric:demo.trans.latency
  -o, --op           Operator: gt|ge|lt|le|eq|ne. Default: gt
  -v, --threshold    Numeric threshold. Default: 200
      --scope        any|all (any means at least one MTS must satisfy; all means every MTS). Default: any
  -h, --help         Show this help.

Exit codes:
  0 -> Criterion NOT met.
  1 -> Criterion met.
  2 -> Error.
USAGE
}

# Defaults
QUERY='sf_metric:demo.trans.latency'
OP='gt'
THRESHOLD='200'
SCOPE='any'

# Parse args
if [[ $# -eq 0 ]]; then
  print_usage
  exit 2
fi

REALM=''
TOKEN=''

while [[ $# -gt 0 ]]; do
  case "$1" in
    -r|--realm)
      REALM="${2:-}"; shift 2;;
    -t|--token)
      TOKEN="${2:-}"; shift 2;;
    -q|--query)
      QUERY="${2:-}"; shift 2;;
    -o|--op)
      OP="${2:-}"; shift 2;;
    -v|--threshold)
      THRESHOLD="${2:-}"; shift 2;;
    --scope)
      SCOPE="${2:-}"; shift 2;;
    -h|--help)
      print_usage; exit 0;;
    *)
      echo "Unknown argument: $1" >&2
      print_usage
      exit 2;;
  esac
done

# Validate inputs
if [[ -z "${REALM}" || -z "${TOKEN}" ]]; then
  echo "Error: --realm and --token are required." >&2
  exit 2
fi

case "${OP}" in
  gt|ge|lt|le|eq|ne) : ;;
  *) echo "Error: Invalid operator '${OP}'. Use gt|ge|lt|le|eq|ne." >&2; exit 2;;
esac

case "${SCOPE}" in
  any|all) : ;;
  *) echo "Error: Invalid scope '${SCOPE}'. Use any|all." >&2; exit 2;;
esac

# Check dependencies
for dep in curl jq awk; do
  command -v "$dep" >/dev/null 2>&1 || { echo "Error: Required command '$dep' not found in PATH." >&2; exit 2; }
done

# URL-encode query via jq
ENCODED_QUERY="$(printf '%s' "${QUERY}" | jq -sRr @uri)"

URL="https://api.${REALM}.signalfx.com/v1/timeserieswindow?query=${ENCODED_QUERY}"

# Perform request; capture body and HTTP status separately
response="$(curl -sS -L \
  -H "X-SF-Token: ${TOKEN}" \
  -H "Content-Type: application/json" \
  -w $'\n%{http_code}' \
  "${URL}" 2>&1 || true)"

http_code="${response##*$'\n'}"
json_body="${response%$'\n'*}"

if ! [[ "$http_code" =~ ^[0-9]{3}$ ]]; then
  echo "Error: Failed to contact API. Raw response:" >&2
  echo "$response" >&2
  exit 2
fi

if [[ "$http_code" != "200" ]]; then
  echo "Error: HTTP ${http_code} from API." >&2
  echo "$json_body" | jq -C . 2>/dev/null || echo "$json_body" >&2
  exit 2
fi

# Optional: Check API-level code field
api_code="$(printf '%s' "$json_body" | jq -r '.code // empty' 2>/dev/null || true)"
if [[ -n "$api_code" && "$api_code" != "200" ]]; then
  echo "Error: API returned code=${api_code}." >&2
  echo "$json_body" | jq -C . 2>/dev/null || echo "$json_body" >&2
  exit 2
fi

# Extract latest values (one per MTS) from data object.
# For each key: take the last datapoint and extract its value [1].
# Result: one numeric value per line.
latest_values="$(printf '%s' "$json_body" | jq -r '
  (.data // {})
  | to_entries
  | map(select(.value | type=="array" and (length > 0)) | .value[-1][1])
  | .[]?
')"

found_n=0
matched_n=0

test_op() {
  # Arguments: value op threshold
  awk -v a="$1" -v op="$2" -v b="$3" 'BEGIN {
    if (op=="gt") exit !(a>b);
    else if (op=="ge") exit !(a>=b);
    else if (op=="lt") exit !(a<b);
    else if (op=="le") exit !(a<=b);
    else if (op=="eq") exit !(a==b);
    else if (op=="ne") exit !(a!=b);
    else exit 2
  }'
}

# Iterate values
if [[ -n "$latest_values" ]]; then
  while IFS= read -r val; do
    # Skip empty/non-numeric lines
    [[ -z "$val" ]] && continue
    # shellcheck disable=SC2003
    if awk 'BEGIN{exit ARGC!=2} {exit ($0+0==0 && $0!="0")}' "$val"; then
      : # Numeric enough for awk comparisons
    fi
    found_n=$((found_n + 1))
    if test_op "$val" "$OP" "$THRESHOLD"; then
      matched_n=$((matched_n + 1))
    fi
  done <<< "$latest_values"
fi

meets=false
if [[ "$SCOPE" == "any" ]]; then
  if (( matched_n > 0 )); then meets=true; fi
else
  # all
  if (( found_n > 0 && matched_n == found_n )); then meets=true; fi
fi

if $meets; then
  echo "Criteria met (${matched_n}/${found_n}) for query '${QUERY}' with ${OP} ${THRESHOLD}."
  # Per request: return zero when the criterion is met.
  exit 0
else
  echo "Criteria NOT met (${matched_n}/${found_n}) for query '${QUERY}' with ${OP} ${THRESHOLD}."
  # Per request: return non-zero when the criterion is not met.
  exit 1
fi