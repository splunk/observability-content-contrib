#!/usr/bin/env -S uv run --script
# /// script
# dependencies = ["requests"]
# ///

"""
Monitors Splunk Observability Cloud token expiration.
Retrieves token info, calculates expiry, sends metrics to Splunk O11y.
Supports API token auth or Session token auth (with caching).
Configuration via environment variables and command-line arguments.

Author: Brandon Blinderman
Version: 04/18/25

Example Usage:
    ./splunk_o11y_token_health.py --realm us0 --api-token YOUR_API_TOKEN --ingest-token YOUR_INGEST_TOKEN
    ./splunk_o11y_token_health.py --use-session --email a@abc.com --password pass --org-id 123 --realm us1 --ingest-token XXXXXXXX...
"""

import requests
import datetime
import json
import os
import sys
import argparse
import time
import enum
from typing import List, Dict, Optional, Any, Tuple

# --- Config Constants ---
ENV_REALM = 'SPLUNK_REALM'
ENV_EMAIL = 'SPLUNK_EMAIL'
ENV_PASSWORD = 'SPLUNK_PASSWORD'
ENV_ORG_ID = 'SPLUNK_ORG_ID'
ENV_API_TOKEN = 'SPLUNK_API_TOKEN'
ENV_INGEST_TOKEN = 'SPLUNK_INGEST_TOKEN'

DEFAULT_REALM = 'us1'
DEFAULT_PAGE_SIZE = 100
SESSION_CACHE_FILE = '.session_token_cache.json'
SESSION_CACHE_DURATION_SECONDS = 55 * 60  # Cache session token for 55 mins

TOKEN_EXPIRY_DAYS = "token.days_until_expiration"

# Default filtering bounds
DEFAULT_MAX_DAYS_AHEAD = 100
DEFAULT_MAX_DAYS_AGO = -30

class ExpirationThreshold(enum.IntEnum):
    """Defines thresholds for token expiration warnings."""
    CRITICAL = 7
    WARNING = 30

# --- API Client Class ---
class SplunkObservabilityClient:
    """Client for interacting with Splunk Observability Cloud APIs."""

    def __init__(self, realm: str, auth_token: str):
        """Initialize the client."""
        if not realm:
            raise ValueError("Realm cannot be empty")
        if not auth_token:
            raise ValueError("Authentication token cannot be empty")

        self.realm = realm
        self.base_api_url = f"https://api.{self.realm}.signalfx.com"
        self.base_ingest_url = f"https://ingest.{self.realm}.signalfx.com"
        self._session = requests.Session()
        self._session.headers.update({
            'X-SF-TOKEN': auth_token,
            'Content-Type': 'application/json'
        })

    def __enter__(self): return self
    def __exit__(self, exc_type, exc_val, exc_tb): self.close()

    def close(self):
        """Close the underlying requests session."""
        if self._session:
            self._session.close()

    def _handle_request_error(self, error: requests.exceptions.RequestException, url: str):
        """Centralized handling for request exceptions."""
        error_message = f"Error accessing {url}: {str(error)}"
        if isinstance(error, requests.exceptions.HTTPError):
            reason = getattr(error.response, 'reason', 'Unknown Reason')
            status_code = getattr(error.response, 'status_code', 'N/A')
            error_message = f"HTTP Error accessing {url}: {status_code} {reason}"
            print(f"{error_message}. Check API permissions, endpoint status, and token validity.")
        else:
            print(error_message)

    def _request(self, method: str, url: str, **kwargs) -> Optional[Any]:
        """Makes an HTTP request, handling common errors."""
        try:
            response = self._session.request(method, url, **kwargs)
            response.raise_for_status()
            if response.status_code == 204:
                return True
            content_type = response.headers.get('Content-Type', '')
            if 'application/json' in content_type:
                return response.json()
            return response.text
        except requests.exceptions.RequestException as e:
            self._handle_request_error(e, url)
            return None
        except json.JSONDecodeError as e:
            print(f"Error decoding JSON response from {url}: {str(e)}")
            response_text = getattr(response, 'text', 'N/A')
            print(f"Response text hint: {response_text[:200]}")
            return None

    def get_all_tokens(self, page_size: int = DEFAULT_PAGE_SIZE) -> Optional[List[Dict[str, Any]]]:
        """Retrieve all tokens using pagination."""
        api_url = f"{self.base_api_url}/v2/token"
        all_tokens = []
        next_cursor = None
        page_count = 0
        print(f"Retrieving token information from {self.realm} realm...")

        while True:
            page_count += 1
            params = {"limit": page_size}
            if next_cursor:
                params["cursor"] = next_cursor
            data = self._request('GET', api_url, params=params)
            if data is None:
                print("Failed to retrieve tokens page due to API error.")
                return None
            if not isinstance(data, dict):
                print(f"Unexpected response format from token API (Page {page_count}): {type(data)}")
                return None
            tokens_on_page = data.get('results', [])
            if not isinstance(tokens_on_page, list):
                print(f"Warning: API response 'results' field was not a list (Page {page_count}). Aborting.")
                return None
            all_tokens.extend(tokens_on_page)
            next_cursor = data.get("nextPageToken") or data.get("cursor")
            if not next_cursor:
                break
        # Correction: Ellipsis removed, added missing indent for print statement
        print(f"Successfully retrieved {len(all_tokens)} tokens.")
        return all_tokens

    def send_datapoints(self, datapoints: List[Dict[str, Any]], ingest_token: str) -> bool:
        """Send gauge datapoints to Splunk Observability Cloud."""
        if not datapoints:
            print("No datapoints provided to send.")
            return True
        if not ingest_token:
            print("Error: Ingest token is missing. Cannot send datapoints.")
            return False

        ingest_url = f"{self.base_ingest_url}/v2/datapoint"
        payload = {"gauge": datapoints}
        headers = {'Content-Type': 'application/json', 'X-SF-TOKEN': ingest_token}

        print(f"Sending {len(datapoints)} datapoints to {self.realm}...")
        try:
            response = requests.post(ingest_url, headers=headers, json=payload, timeout=30)
            response.raise_for_status()
            result = response.text
            if result is not None and str(result).strip().upper() == '"OK"':
                print("Successfully sent metrics.")
                return True
            else:
                print(f"Metrics sent. API response indicated success but was not the expected '\"OK\"'. Response hint: {str(result)[:100]}")
                return True
        except requests.exceptions.RequestException as e:
            self._handle_request_error(e, ingest_url)
            print("Failed to send metrics.")
            return False

    @staticmethod
    def create_session_token(realm: str, email: str, password: str, org_id: str) -> Optional[str]:
        """Create a session token using email/password. Static method."""
        session_url = f"https://api.{realm}.signalfx.com/v2/session"
        payload = {"email": email, "password": password, "organizationId": org_id}
        headers = {"Content-Type": "application/json"}
        print("Attempting to create session token...")
        try:
            response = requests.post(session_url, headers=headers, json=payload, timeout=30)
            response.raise_for_status()
            session_data = response.json()
            session_token = session_data.get("accessToken")
            if not session_token:
                print("Error: Session token creation succeeded but 'accessToken' not found in response.")
                return None
            print("Session token created successfully.")
            return session_token
        except requests.exceptions.Timeout:
            print(f"Error: Request timed out creating session token at {session_url}.")
            return None
        except requests.exceptions.HTTPError as e:
            status_code = getattr(e.response, 'status_code', 'N/A')
            reason = getattr(e.response, 'reason', 'Unknown Reason')
            print(f"HTTP Error creating session token: {status_code} {reason}")
            if status_code == 401:
                print(" -> Unauthorized: Check email, password, organization ID, and ensure SSO is not enabled if using this method.")
            elif status_code == 404:
                print(f" -> Not Found: Verify the realm ('{realm}') and organization ID are correct.")
            else:
                print(" -> Check credentials, org ID, realm, and Splunk Observability Cloud status.")
            return None
        except requests.exceptions.RequestException as e:
            print(f"Error creating session token: {str(e)}")
            return None
        except json.JSONDecodeError as e:
            print(f"Error decoding session token response: {str(e)}")
            response_text = getattr(response, 'text', 'N/A')
            print(f"Response text hint: {response_text[:200]}")
            return None
        # Correction: Removed ellipsis

# --- Session Token Caching Functions ---
def load_session_token_cache(cache_file: str, max_age_seconds: int) -> Optional[str]:
    """Loads session token from cache file if valid and not expired."""
    if not os.path.exists(cache_file):
        return None
    try:
        cache_mtime = os.path.getmtime(cache_file)
        if time.time() - cache_mtime > max_age_seconds:
            print("Session token cache file expired.")
            os.remove(cache_file)
            return None
        with open(cache_file, 'r') as f:
            cache_data = json.load(f)
            if isinstance(cache_data, dict) and 'token' in cache_data and 'timestamp' in cache_data:
                if time.time() - cache_data['timestamp'] > max_age_seconds:
                    print("Session token cache content expired.")
                    os.remove(cache_file)
                    return None
                print(f"Using cached session token from {cache_file}.")
                return cache_data['token']
            else:
                print("Invalid session token cache file format. Ignoring.")
                os.remove(cache_file)
                return None
    except (IOError, json.JSONDecodeError, os.error) as e:
        print(f"Error reading or managing session token cache file {cache_file}: {e}. Ignoring cache.")
        try:
            if os.path.exists(cache_file):
                os.remove(cache_file)
        except os.error as rm_err:
            print(f"Warning: Could not remove potentially corrupt cache file {cache_file}: {rm_err}")
        return None

def save_session_token_cache(cache_file: str, token: str) -> None: # Added return type hint
    """Saves session token to the cache file with a timestamp."""
    try:
        cache_content = {'token': token, 'timestamp': time.time()}
        with open(cache_file, 'w') as f:
            json.dump(cache_content, f)
        print(f"Session token cached successfully to {cache_file}.")
    except (IOError, TypeError) as e:
        print(f"Error writing session token cache file {cache_file}: {e}")

# --- Helper Functions ---
def _parse_timestamp_ms(timestamp_ms: Optional[int]) -> Optional[datetime.datetime]:
    """Safely parse millisecond timestamp to datetime object (UTC)."""
    if timestamp_ms is None:
        return None
    try:
        return datetime.datetime.fromtimestamp(timestamp_ms / 1000.0, tz=datetime.timezone.utc)
    except (TypeError, ValueError):
        return None

def _create_datapoint(metric_name: str, value: Any, dimensions: Dict[str, Any]) -> Dict[str, Any]:
    """Helper to create a standard gauge datapoint dictionary."""
    safe_dimensions = {k: str(v)[:255] for k, v in dimensions.items()}
    return {"metric": metric_name, "value": value, "dimensions": safe_dimensions}

def process_and_prepare_datapoints(raw_tokens: List[Dict[str, Any]], include_all_tokens: bool) -> Tuple[List[Dict[str, Any]], Dict[str, int]]: # Added flag argument
    """
    Processes raw token data, generates datapoints, and calculates summary counts in a single pass.
    By default, filters out tokens expiring > 100 days or expired > 30 days ago.

    Args:
        raw_tokens: List of token dictionaries from the API.
        include_all_tokens: If True, bypasses the default expiry range filtering.

    Returns:
        A tuple containing:
        - List of datapoint dictionaries ready for sending.
        - Dictionary with summary counts ('processed', 'expired', 'critical', 'warning').
    """
    datapoints = []
    summary_counts = {'processed': 0, 'expired': 0, 'critical': 0, 'warning': 0, 'filtered_out': 0} # Added filtered_out count
    current_time = datetime.datetime.now(datetime.timezone.utc)

    print("Processing token data and preparing datapoints...")
    for token in raw_tokens:
        token_name = token.get('name', 'Unnamed Token')
        token_id = token.get('id', 'Unknown ID')
        token_type = token.get('type', 'Unknown Type')

        # Filter out tokens we don't want to process/metric
        if token_type == 'SessionToken':
            continue

        expiration_date = _parse_timestamp_ms(token.get('expiry'))
        if not expiration_date:
            continue # Skip tokens without a valid expiration date

        # Calculate days remaining
        days_until_expiration = (expiration_date - current_time).days

        # Apply default filtering unless bypassed by the flag
        if not include_all_tokens:
            if days_until_expiration > DEFAULT_MAX_DAYS_AHEAD or days_until_expiration < DEFAULT_MAX_DAYS_AGO:
                summary_counts['filtered_out'] += 1
                continue # Skip this token

        # Increment processed count ONLY for tokens that pass ALL filters
        summary_counts['processed'] += 1

        # Check expiration status and update counts/print warnings
        if days_until_expiration < 0:
            # Note: Expired tokens < -30 days are already filtered out above if default filtering is active
            print(f"  -> EXPIRED: Token '{token_name}' (ID: {token_id}) expired on {expiration_date.strftime('%Y-%m-%d')}.")
            summary_counts['expired'] += 1
        elif days_until_expiration <= ExpirationThreshold.CRITICAL:
            print(f"  -> CRITICAL: Token '{token_name}' (ID: {token_id}) expires in {days_until_expiration} days ({expiration_date.strftime('%Y-%m-%d')})")
            summary_counts['critical'] += 1
        elif days_until_expiration <= ExpirationThreshold.WARNING:
            print(f"  -> WARNING: Token '{token_name}' (ID: {token_id}) expires in {days_until_expiration} days ({expiration_date.strftime('%Y-%m-%d')})")
            summary_counts['warning'] += 1
        # Correction: Removed ellipsis

        # Prepare datapoint directly
        base_dims = {"token_name": token_name, "token_id": token_id, "token_type": token_type}
        exp_dims = base_dims.copy()
        exp_dims["expiration_date"] = expiration_date.strftime('%Y-%m-%d %H:%M:%S %Z')
        scopes = token.get('authScopes', [])
        exp_dims["auth_scopes"] = ",".join(sorted(scopes)) if isinstance(scopes, list) and scopes else "None"

        datapoints.append(_create_datapoint(
            TOKEN_EXPIRY_DAYS, days_until_expiration, exp_dims))

    filter_msg = f" {summary_counts['filtered_out']} tokens filtered out due to default expiry range." if not include_all_tokens and summary_counts['filtered_out'] > 0 else ""
    print(f"Processing complete. Prepared {len(datapoints)} datapoints for {summary_counts['processed']} relevant tokens.{filter_msg}")
    return datapoints, summary_counts

# --- Configuration Handling ---
def parse_args() -> argparse.Namespace:
    """Parse command line arguments."""
    example_usage = """
Examples:
  # API token (recommended):
  export SPLUNK_REALM=us1 SPLUNK_API_TOKEN=... SPLUNK_INGEST_TOKEN=...
  ./splunk_o11y_token_health.py

  # Session Token (non-SSO org, caches token):
  export SPLUNK_REALM=eu0 SPLUNK_EMAIL=... SPLUNK_PASSWORD='...' SPLUNK_ORG_ID=... SPLUNK_INGEST_TOKEN=...
  ./splunk_o11y_token_health.py --use-session

  # Dry run:
  ./splunk_o11y_token_health.py --dry-run

  # Include all tokens (disable default filtering >100 days ahead, < -30 days ago):
  ./splunk_o11y_token_health.py --include-all-tokens"""

    parser = argparse.ArgumentParser(
        description='Monitor token expiration in Splunk Observability Cloud. Config priority: CLI > Env Vars > Defaults.',
        formatter_class=argparse.RawDescriptionHelpFormatter, epilog=example_usage)

    parser.add_argument('--use-session', action='store_true', default=False,
                        help=f'Use session auth via email/password ({ENV_EMAIL}, {ENV_PASSWORD}, {ENV_ORG_ID}). Caches token for ~{SESSION_CACHE_DURATION_SECONDS//60} mins. Does NOT work if SSO is enabled.')
    parser.add_argument('--realm', type=str, default=os.environ.get(
        ENV_REALM, DEFAULT_REALM), help=f'Splunk realm. Env: ${ENV_REALM}')
    parser.add_argument('--ingest-token', type=str, default=os.environ.get(
        ENV_INGEST_TOKEN), help=f'Splunk Ingest token. Env: ${ENV_INGEST_TOKEN}')
    parser.add_argument('--email', type=str, default=os.environ.get(
        ENV_EMAIL), help=f'Email for session auth. Env: ${ENV_EMAIL}')
    parser.add_argument('--password', type=str, default=os.environ.get(
        ENV_PASSWORD), help=f'Password for session auth. Use ${ENV_PASSWORD} env var for safety.')
    parser.add_argument('--org-id', type=str, default=os.environ.get(
        ENV_ORG_ID), help=f'Organization ID for session auth. Env: ${ENV_ORG_ID}')
    parser.add_argument('--api-token', type=str, default=os.environ.get(
        ENV_API_TOKEN), help=f'API token for API access (default auth). Env: ${ENV_API_TOKEN}')
    parser.add_argument('--page-size', type=int,
                        default=DEFAULT_PAGE_SIZE, help='Tokens to fetch per API request.')
    parser.add_argument('--dry-run', action='store_true',
                        default=False, help='Perform all steps except sending metrics.')
    parser.add_argument('--include-all-tokens', action='store_true', default=False,
                        help='Include all tokens regardless of expiry date, bypassing the default filter (>{DEFAULT_MAX_DAYS_AHEAD}d, <{DEFAULT_MAX_DAYS_AGO}d).')
    return parser.parse_args()

def validate_config(config: Dict[str, Any], password_from_cli: bool) -> bool:
    """
    Validates presence of necessary config based on auth method.

    Args:
        config: Dictionary of configuration values.
        password_from_cli: Boolean indicating if the password was sourced from the CLI arg.
    """
    is_valid = True
    auth_method = "Session Token" if config['use_session'] else "API Token"
    print(f"Attempting configuration for {auth_method} authentication.")
    # Correction: Removed ellipsis
    if config['use_session']:
        if not all([config['email'], config['password'], config['org_id']]):
            print(f"Error: --use-session requires email, password, and org ID. Set via CLI or env vars ({ENV_EMAIL}, {ENV_PASSWORD}, {ENV_ORG_ID}).")
            is_valid = False
        # Use the passed flag instead of re-parsing args
        if password_from_cli:
            print(f"Warning: Using password via --password arg. Recommend using ${ENV_PASSWORD} env var.")
    else: # API Token Auth
        if not config['api_token']:
            print(f"Error: API token required if not using session auth. Set via --api-token or ${ENV_API_TOKEN}.")
            is_valid = False

    if not config['ingest_token'] and not config['dry_run']:
        print(f"Error: Ingest token required unless in --dry-run mode. Set via --ingest-token or ${ENV_INGEST_TOKEN}.")
        is_valid = False
    elif not config['ingest_token'] and config['dry_run']:
        print("Info: Ingest token not provided, but continuing in --dry-run mode.")

    if not config['realm']:
        print("Error: Realm is required.")
        is_valid = False

    if is_valid:
        print("Configuration validated successfully.")
    return is_valid

# Updated Summary function to accept counts directly
def print_summary(config: Dict[str, Any],
                  raw_token_count: Optional[int],
                  summary_counts: Dict[str, int],
                  datapoint_count: int,
                  metrics_sent_status: bool) -> None: # Added return type hint
    """Execution summary."""
    print("\n=== Execution Summary ===")
    print(f"Realm: {config.get('realm', 'N/A')}")
    print(f"Authentication Method: {'Session Token' if config.get('use_session') else 'API Token'}")
    print(f"Dry Run Mode: {'Enabled' if config.get('dry_run') else 'Disabled'}")
    print(f"Tokens Retrieved from API: {raw_token_count if raw_token_count is not None else 'Failed'}")

    # Use counts directly from the summary_counts dict
    processed_count = summary_counts.get('processed', 0)
    filtered_count = summary_counts.get('filtered_out', 0)
    filter_status = "Disabled" if config.get('include_all_tokens') else "Enabled (default)"
    print(f"Default Expiry Filtering (> {DEFAULT_MAX_DAYS_AHEAD}d, < {DEFAULT_MAX_DAYS_AGO}d): {filter_status}")
    print(f"Tokens Filtered Out by Expiry Range: {filtered_count}")
    print(f"Relevant Tokens Processed (post-filter): {processed_count}")
    print(f"Datapoints Prepared: {datapoint_count}")


    if config.get('dry_run'):
        print("Metrics Sent: No (Dry Run mode enabled)")
    else:
        print(f"Metrics Sent Successfully: {'Yes' if metrics_sent_status else 'No'}")

    # Use counts directly from the summary_counts dict
    expired_count = summary_counts.get('expired', 0)
    crit_count = summary_counts.get('critical', 0)
    warn_count = summary_counts.get('warning', 0)
    total_expiring_or_warn = expired_count + crit_count + warn_count # Simplified logic

    print("\n--- Expiration Status (Post-Filtering) ---") # Clarified title
    if expired_count > 0:
        print(f"🔴 {expired_count} token(s) ALREADY EXPIRED (within {abs(DEFAULT_MAX_DAYS_AGO)} days).") # Added range context
    if crit_count > 0:
        print(f"❗️ {crit_count} token(s) expiring within {ExpirationThreshold.CRITICAL} days (CRITICAL)")
    if warn_count > 0:
        print(f"⚠️  {warn_count} token(s) expiring between {ExpirationThreshold.CRITICAL+1} and {ExpirationThreshold.WARNING} days (WARNING)")

    # Use processed_count and total_expiring_or_warn for summary message
    if processed_count > 0 and total_expiring_or_warn == 0 :
        print(f"✅ No relevant tokens expiring within {ExpirationThreshold.WARNING} days or recently expired.")
    elif processed_count == 0 and raw_token_count is not None and raw_token_count > 0:
        print("ℹ️  No relevant tokens remaining after filtering.")
    elif processed_count == 0: # Handles case where raw_token_count is None or 0
         print("ℹ️  No relevant tokens with expiration dates were processed.")


# --- Main Execution ---
def main():
    """Tying it all together"""
    start_time = time.time()
    print(f"Script started at {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")

    args = parse_args()
    config = vars(args) # Now includes 'include_all_tokens'

    password_env = os.environ.get(ENV_PASSWORD)
    password_arg = args.password
    # True if password came specifically from CLI arg and differs from (or missing) env var
    password_from_cli = password_arg is not None and password_arg != password_env

    if not validate_config(config, password_from_cli): # Pass the flag here
        sys.exit(1)

    # --- Determine Auth Token (Handle Session Token Cache) ---
    auth_token = None
    if config['use_session']:
        auth_token = load_session_token_cache(SESSION_CACHE_FILE, SESSION_CACHE_DURATION_SECONDS)
        if auth_token is not None:  # Cache hit!
            cache_message = (
                f"\nINFO: Using valid cached session token found in '{SESSION_CACHE_FILE}'.\n"
                f"      Token: {auth_token}\n"
                "      Hint: You can skip --use-session and credentials by using this token directly:\n"
                f"            export SPLUNK_API_TOKEN='{auth_token}'\n"
                "            # OR\n"
                f"            --api-token '{auth_token}'\n"
            )
            print(cache_message)
        else:  # Cache miss or expired
            print("No valid cached session token found.")
            auth_token = SplunkObservabilityClient.create_session_token(
                config['realm'], config['email'], config['password'], config['org_id']
            )
            if auth_token:
                save_session_token_cache(SESSION_CACHE_FILE, auth_token)
            else:
                print("Session token creation failed. Exiting.")
                sys.exit(1)
    else:
        auth_token = config['api_token']

    # Initializing the client and kicking off the workflow
    raw_tokens = None
    datapoints = []
    summary_counts = {'processed': 0, 'expired': 0, 'critical': 0, 'warning': 0, 'filtered_out': 0} # Ensure filtered_out key exists
    metrics_sent_successfully = False

    try:
        with SplunkObservabilityClient(config['realm'], auth_token) as client:
            raw_tokens = client.get_all_tokens(page_size=config['page_size'])

            if raw_tokens is not None:
                # Pass the include_all_tokens flag from config
                datapoints, summary_counts = process_and_prepare_datapoints(raw_tokens, config['include_all_tokens'])

                # Send metrics or handle dry run
                if config['dry_run']:
                    print("\n--- Dry Run Mode Enabled ---")
                    if datapoints:
                        print(f"Would send {len(datapoints)} datapoints:")
                        print(json.dumps({"gauge": datapoints}, indent=2))
                    else:
                        print("No datapoints would be sent.")
                    metrics_sent_successfully = True
                elif datapoints:
                    metrics_sent_successfully = client.send_datapoints(datapoints, config['ingest_token'])
                else:
                    metrics_sent_successfully = True # Success if no datapoints needed sending

            else:  # raw_tokens fetch failed
                print("Could not retrieve token information. Exiting.")
                metrics_sent_successfully = False

    except ValueError as e:  # Catch client init errors
        print(f"Error initializing Splunk client: {e}")
        metrics_sent_successfully = False

    # --- Print Summary and Exit ---
    print_summary(
        config=config,
        raw_token_count=len(raw_tokens) if raw_tokens is not None else None,
        summary_counts=summary_counts,
        datapoint_count=len(datapoints),
        metrics_sent_status=metrics_sent_successfully,
    )

    end_time = time.time()
    print(f"\nScript finished in {end_time - start_time:.2f} seconds.")
    sys.exit(0 if metrics_sent_successfully else 1)


if __name__ == "__main__":
    main()
