# General Recommendations for Integration and API Example Content for Reuse

Integration Examples can be everything from example code for interacting with APIs, Configurations for Open Telemetry, code for getting custom metrics into Observability, and more.

1. **Noun-centric Organization** : Integrations and API interactions are generally composed of common software components/platforms.

    Please organize folders and submissions to group similar software and platforms together. 

    Integrations should be oriented towards specific software/platforms with a focus on reusable patterns wherever possible for easily adjusting to a specific customer's needs. 

2. **Integrations** : Loosely integrations covers collections of code, scripts, documentation, etc which will aide others in setting up functionality with Splunk Observability. This could include Getting Data In (GDI), Tips and reusable SignalFlow patterns, Webhook setup information for a vendor, serverless code for performing checks, etc

    Include a `README.md` within your submission directory documenting and detailing the process of using your Submisson. If metrics are produced, include a list of those metrics and any associated dimensions in your `README.md`.

3. **OpenTelemetry Configurations** : Integrations using OpenTelemetry should include OpenTelemetry config files along with a `README.md` that briefly describes any novel pipelines and the receivers, processors, and exporters used.

4. **API Scripts and Interactions** : API Scripts and Interactions should include a `README.md` file that explains what the script does. If it emits metrics and dimensions for those metrics they should be noted in the `README.md` file.

    Double check and verify that you have not accidentally added your API tokens or secrets with your code. Wherever possible use environment variables to pass these secrets to the script.
