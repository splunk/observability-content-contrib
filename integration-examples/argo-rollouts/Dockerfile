FROM alpine:3.20

# Install minimal runtime deps for the script.
# - bash: required by the script.
# - curl: to call the API.
# - jq: to parse JSON and URL-encode the query.
# - ca-certificates: to trust HTTPS endpoints.
RUN apk add --no-cache bash curl jq ca-certificates \
    && update-ca-certificates

# Create non-root user.
RUN addgroup -S app && adduser -S -G app app

# Copy the script into the image.
# Ensure the script is named exactly as below in your build context.
COPY check_splunk_metric.sh /usr/local/bin/check_splunk_metric.sh
RUN chmod +x /usr/local/bin/check_splunk_metric.sh \
    && chown app:app /usr/local/bin/check_splunk_metric.sh

USER app

# Default entrypoint to the script; pass flags via `docker run ...`.
ENTRYPOINT ["/usr/local/bin/check_splunk_metric.sh"]
# Uncomment to show help by default instead of usage error:
# CMD ["--help"]