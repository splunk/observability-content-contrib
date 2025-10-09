# MetricsHub Detectors

This folder contains detectors that may be used to trigger events based on the metrics collected by MetricsHub.

Please note that you may want or need different thresholds than those provided here.
You may also want to create your own detectors.

## Importing Detectors
Two options exist:
1. Edit and send the Detector JSON [via API](https://dev.splunk.com/observability/reference/api/detectors/latest#endpoint-create-single-detector)
  ```
  curl -X POST "https://api.{REALM}.signalfx.com/v2/detector" \
    -H "Content-Type: application/json" \
    -H "X-SF-TOKEN: <value>" \
    -d @"/path/to/detector/detector_name.json"
  ```
2. Copy the detector's JSON and paste it into your own Detector [via the UI](https://docs.splunk.com/Observability/alerts-detectors-notifications/create-detectors-for-alerts.html#nav-Create-detectors-to-trigger-alerts)

# Support

Subscribers to **MetricsHub** gain access to the **MetricsHub Support Desk**, which provides:

- Technical support
- Patches and updates
- Knowledge base access

For more information, visit the [MetricsHub](https://metricshub.com/) website.

Splunk does not provide support for these detectors and users should contact Sentry Software's support with any support requests.

