# Splunk Observability Token Expiration Monitor

A tool to monitor Splunk Observability Cloud token expiration. Fetches tokens, calculates expiry, and sends `token.days_until_expiration` as a custom metric for monitoring and alerting.

## Prerequisites

* [`uv`](https://github.com/astral-sh/uv) installed
* The script uses the `uv run --script` header to manage its dependencies automatically
* Make the script executable: `chmod +x splunk_o11y_token_health.py`

## Configuration

Configure via environment variables or CLI arguments. CLI arguments take precedence.

### Required:

* **Realm:** Splunk Observability realm (e.g., `us0`, `us1`)
  * Env: `SPLUNK_REALM`
  * CLI: `--realm` (Default: `us1`)

* **Authentication:** The script needs a session token to authenticate with Splunk Observability Cloud
  * **Option 1: Automatic Session Token Creation** (for non-SSO organizations only):
    * This method uses the API to generate a session token automatically
    * Caches token for ~55 mins (`.session_token_cache.json`)
    * Env: `SPLUNK_EMAIL`, `SPLUNK_PASSWORD`, `SPLUNK_ORG_ID`
    * CLI: `--use-session`, `--email`, `--password`, `--org-id` (Use `$SPLUNK_PASSWORD` env var for safety)
    * **Note:** This method will not work if your organization uses SSO.

  * **Option 2: Pre-obtained Session Token** (works for all organizations, including SSO):
    * Manually obtain a session token from the Splunk Observability Cloud UI
    * Env: `SPLUNK_API_TOKEN` (despite the name, this should be a session token)
    * CLI: `--api-token`

    > **Important:** For SSO-enabled organizations, Option 1 will not work. You must use Option 2.

* **Ingest Token:** Splunk Observability Ingest token (requires ingest permissions)
  * Env: `SPLUNK_INGEST_TOKEN`
  * CLI: `--ingest-token` (Not needed if using `--dry-run`)

**Optional:**

* `--page-size`: Tokens per API request (Default: 100)
* `--dry-run`: Process data and show planned metrics, but do not send them
* `--include-all-tokens`: disables default expiry filtering (see below); includes all valid tokens.

## Default Expiry filtering

By default, the script only processes and sends metrics for tokens that meet these criteria:
*   Expire within the next **100 days** (`<= 100`).
*   Have expired within the last **30 days** (`>= -30`).

Use the `--include-all-tokens` flag to bypass this filter and process all tokens with valid expiration dates

## Usage

Ensure the script is executable (`chmod +x splunk_o11y_token_health.py`). Since the script uses the `uv run --script` header, `uv` will handle the environment and dependencies when you execute it directly.

### 1. Using Pre-obtained Session Token (Option 2, works for all organizations):

```bash
# Set required environment variables
export SPLUNK_REALM="us1"
export SPLUNK_API_TOKEN="YOUR_SESSION_TOKEN"  # Session token from Splunk O11y UI
export SPLUNK_INGEST_TOKEN="YOUR_INGEST_TOKEN"

# Execute the script directly
./splunk_o11y_token_health.py
```

### 2. Using Automatic Session Token Creation (Option 1, non-SSO orgs only):

```bash
# Set required environment variables
export SPLUNK_REALM="eu0"
export SPLUNK_EMAIL="your.email@example.com"
export SPLUNK_PASSWORD='your_secret_password' # Use env var!
export SPLUNK_ORG_ID="YOUR_ORG_ID"
export SPLUNK_INGEST_TOKEN="YOUR_INGEST_TOKEN"

# Execute the script with the session flag.
./splunk_o11y_token_health.py --use-session
```

> **Note:** Cached tokens are reused automatically if valid.

### 3. Dry Run:

```bash
# Assumes required auth env vars are set
./splunk_o11y_token_health.py --dry-run
```

### 4. Disable Default filtering

```bash
./splunk_o11y_token_health.py --include-all-tokens
```


## Output Metric

Sends a gauge metric to Splunk Observability Cloud:

* **`token.days_until_expiration`**: Days until token expiry (negative if expired)
  * **Dimensions:** `token_name`, `token_id`, `token_type`, `expiration_date`, `auth_scopes`

## Session Token Caching

When using `--use-session`, a successfully created session token is cached in `.session_token_cache.json` for approximately 55 minutes. Subsequent runs with `--use-session` within this period will reuse the cached token. API token authentication (`--api-token`) does not use this cache.

## Exit Codes

* **0**: Success (metrics sent, or dry run completed, or no relevant tokens found)
* **1**: Failure (configuration error, API error, metric sending failed)

## References
- https://dev.splunk.com/observability/reference/api/sessiontokens/latest
- https://dev.splunk.com/observability/reference/api/org_tokens/latest#endpoint-retrieve-tokens-using-query
- https://dev.splunk.com/observability/reference/api/ingest_data/latest#endpoint-send-metrics
