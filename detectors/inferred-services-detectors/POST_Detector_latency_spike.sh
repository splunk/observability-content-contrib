curl --location 'https://api.us1.signalfx.com/v2/detector' \
--header 'Content-Type:  application/json' \
--header 'X-SF-TOKEN: REPLACEME' \
--data '{
    "authorizedWriters": {
        "teams": [],
        "users": []
    },
    "customProperties": null,
    "description": "",
    "detectorOrigin": "Standard",
    "labelResolutions": {
        "Latency >3s": 1000
    },
    "maxDelay": 0,
    "minDelay": 0,
    "name": "[sample] Inferred Services - Latency Spike",
    "overMTSLimit": false,
    "programText": "AB = alerts(detector_name='\''[sample] Inferred Services - Latency Spike'\'').publish(label='\''AB'\'')\nA = histogram('\''inferred.services'\'', filter=filter('\''sf_service'\'', '\''*'\'') and filter('\''sf_environment'\'', '\''*'\'')).max(by=['\''sf_operation'\'', '\''sf_environment'\'', '\''sf_service'\'', '\''sf_error'\'']).mean(over='\''1m'\'').publish(label='\''A'\'')\ndetect(when(A > threshold(3000000000), lasting='\''5m'\'', at_least=0.9), auto_resolve_after='\''30m'\'').publish('\''Latency >3s'\'')",
    "rules": [
        {
            "description": "The value of Latency for Operation/Endpoint (1 min avg) is above 3000000000 for 90% of 5m.",
            "detectLabel": "Latency >3s",
            "disabled": false,
            "notifications": [],
            "parameterizedBody": "{{#if anomalous}}\n\tRule \"{{{ruleName}}}\" in detector \"{{{detectorName}}}\" triggered at {{dateTimeFormat timestamp format=\"full\"}}.\n{{else}}\n\tRule \"{{{ruleName}}}\" in detector \"{{{detectorName}}}\" cleared at {{dateTimeFormat timestamp format=\"full\"}}.\n{{/if}}\n\n{{#if anomalous}}\nTriggering condition: {{{readableRule}}}\n{{/if}}\n\n{{#if anomalous}}Signal value for Latency for Operation/Endpoint (1 min avg): {{inputs.A.value}}\n\n{{else}}Current signal value for Latency for Operation/Endpoint (1 min avg): {{inputs.A.value}}\n{{/if}}\nService: {{dimensions.sf_service}}\nEnvironment: {{dimensions.sf_environment}}\nOperation: {{dimensions.sf_operation}}\nError: {{dimensions.sf_error}}\n{{#notEmpty dimensions}}\nSignal details:\n{{{dimensions}}}\n{{/notEmpty}}\n\n{{#if anomalous}}\n{{#if runbookUrl}}Runbook: {{{runbookUrl}}}{{/if}}\n{{#if tip}}Tip: {{{tip}}}{{/if}}\n{{/if}}",
            "severity": "Warning"
        }
    ],
    "sf_metricsInObjectProgramText": [
        "inferred.services"
    ],
    "status": "ACTIVE",
    "tags": [],
    "teams": [],
    "timezone": "",
    "visualizationOptions": {
        "disableSampling": true,
        "publishLabelOptions": [
            {
                "displayName": "Latency for Operation/Endpoint (1 min avg)",
                "label": "A",
                "paletteIndex": null,
                "valuePrefix": null,
                "valueSuffix": null,
                "valueUnit": "Nanosecond"
            }
        ],
        "showDataMarkers": true,
        "showEventLines": false,
        "time": {
            "range": 900000,
            "rangeEnd": 0,
            "type": "relative"
        }
    }
}'
