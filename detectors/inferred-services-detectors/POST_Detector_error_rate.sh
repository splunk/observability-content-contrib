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
        "Error rate >50%": 2000,
        "Sudden change in Error rate for last 5min": 2000
    },
    "maxDelay": 0,
    "minDelay": 0,
    "name": "[sample] Inferred Services - Error Rate per minute",
    "overMTSLimit": false,
    "programText": "from signalfx.detectors.against_recent import against_recent\nA = histogram('\''inferred.services'\'', filter=filter('\''sf_service'\'', '\''*'\'') and filter('\''sf_environment'\'', '\''*'\'')).count(by=['\''sf_environment'\'', '\''sf_service'\'']).sum(over='\''1m'\'').publish(label='\''A'\'', enable=False)\nB = histogram('\''inferred.services'\'', filter=filter('\''sf_service'\'', '\''*'\'') and filter('\''sf_environment'\'', '\''*'\'') and filter('\''sf_error'\'', '\''false'\'')).count(by=['\''sf_environment'\'', '\''sf_service'\'']).sum(over='\''1m'\'').publish(label='\''B'\'', enable=False)\nC = histogram('\''inferred.services'\'', filter=filter('\''sf_service'\'', '\''*'\'') and filter('\''sf_environment'\'', '\''*'\'') and filter('\''sf_error'\'', '\''true'\'')).count(by=['\''sf_environment'\'', '\''sf_service'\'']).sum(over='\''1m'\'').publish(label='\''C'\'', enable=False)\nD = combine(100*((C if C is not None else 0) / A)).publish(label='\''D'\'')\ndetect(when(D > threshold(50), lasting='\''5m'\'', at_least=0.9), auto_resolve_after='\''30m'\'').publish('\''Error rate >50%'\'')\nagainst_recent.detector_mean_std(stream=D, current_window='\''5m'\'', historical_window='\''15m'\'', fire_num_stddev=3.5, clear_num_stddev=3, orientation='\''above'\'', ignore_extremes=True, calculation_mode='\''vanilla'\'').publish('\''Sudden change in Error rate for last 5min'\'')",
    "rules": [
        {
            "description": "The value of Error rate per min is above 50 for 90% of 5m.",
            "detectLabel": "Error rate >50%",
            "disabled": false,
            "notifications": [],
            "parameterizedBody": "{{#if anomalous}}\n\tRule \"{{{ruleName}}}\" in detector \"{{{detectorName}}}\" triggered at {{dateTimeFormat timestamp format=\"full\"}}.\n{{else}}\n\tRule \"{{{ruleName}}}\" in detector \"{{{detectorName}}}\" cleared at {{dateTimeFormat timestamp format=\"full\"}}.\n{{/if}}\n\n{{#if anomalous}}\nTriggering condition: {{{readableRule}}}\n{{/if}}\n\n{{#if anomalous}}Signal value for Error rate per min: {{inputs.D.value}}\n{{else}}Current signal value for Error rate per min: {{inputs.D.value}}\n{{/if}}\n\n{{#notEmpty dimensions}}\nSignal details:\n{{{dimensions}}}\n{{/notEmpty}}\n\n{{#if anomalous}}\n{{#if runbookUrl}}Runbook: {{{runbookUrl}}}{{/if}}\n{{#if tip}}Tip: {{{tip}}}{{/if}}\n{{/if}}",
            "severity": "Major"
        },
        {
            "description": "All the values of Error rate per min in the last 5m are more than 3.5 standard deviation(s) above the mean of its preceding 15m.",
            "detectLabel": "Sudden change in Error rate for last 5min",
            "disabled": false,
            "notifications": [],
            "parameterizedBody": "{{#if anomalous}}\n\tRule \"{{{ruleName}}}\" in detector \"{{{detectorName}}}\" triggered at {{dateTimeFormat timestamp format=\"full\"}}.\n{{else}}\n\tRule \"{{{ruleName}}}\" in detector \"{{{detectorName}}}\" cleared at {{dateTimeFormat timestamp format=\"full\"}}.\n{{/if}}\n\n{{#if anomalous}}\nTriggering condition: {{{readableRule}}}\n{{/if}}\n\nMinimum value of signal in the last {{event_annotations.current_window}}: {{inputs.recent_min.value}}\n{{#if anomalous}}Trigger threshold: {{inputs.f_top.value}}\n{{else}}Clear threshold: {{inputs.c_top.value}}\n{{/if}}\n\n{{#notEmpty dimensions}}\nSignal details:\n{{{dimensions}}}\n{{/notEmpty}}\n\n{{#if anomalous}}\n{{#if runbookUrl}}Runbook: {{{runbookUrl}}}{{/if}}\n{{#if tip}}Tip: {{{tip}}}{{/if}}\n{{/if}}",
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
        "disableSampling": false,
        "publishLabelOptions": [
            {
                "displayName": "Total Requests / min",
                "label": "A",
                "paletteIndex": 14,
                "valuePrefix": "",
                "valueSuffix": "",
                "valueUnit": null
            },
            {
                "displayName": "Successful Requests / min",
                "label": "B",
                "paletteIndex": 6,
                "valuePrefix": "",
                "valueSuffix": "",
                "valueUnit": null
            },
            {
                "displayName": "Errors / min",
                "label": "C",
                "paletteIndex": 8,
                "valuePrefix": "",
                "valueSuffix": "",
                "valueUnit": null
            },
            {
                "displayName": "Error rate per min",
                "label": "D",
                "paletteIndex": null,
                "valuePrefix": null,
                "valueSuffix": "%",
                "valueUnit": null
            }
        ],
        "showDataMarkers": true,
        "showEventLines": false,
        "time": {
            "range": 172800000,
            "rangeEnd": 0,
            "type": "relative"
        }
    }
}'
