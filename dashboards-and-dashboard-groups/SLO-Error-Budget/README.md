# SLO / SLx Budgeting
Included in this contribution are Terraform files to spin up an Error Budget / SLO integration with Charts / Dashboard and Alert for counting "Alert Minutes". Below you will find an extensive description of the SignalFlow and what it is doing.

## Terraform Files

To use these Terraform files please be sure to edit the following variables in `SLO-SLX.tf`
```tf
variable "slo_service_name" {
    type = string
    #Change this service name to an APM service name in your environment
    default = "placeholder-name-add-your-own-name"
}

variable "detector_name" {
   type = string
   #Change this Detector Name as required
   default = "SLO detector"
}
```
1. `slo_service_name` is the APM service name of your APM service.
2. `detector_name` is the name you would like to give your Alert Minutes detector.

Then spin up the resources as you would anything else using the Signalfx Terraform Provider.
*Note:* Make sure to have a `signalfx_auth_token`!

## SignalFlow Details
This example works off of the alerts() function to COUNT the number of alerts during a given period of time.

This requires:
1. An alert that only ever goes off for a minute at a time.
    - During long stretches of time where alert would be triggered have it turn on/off every minute
    - Likely use a rate for this alert (Error rate is most common)
2. A charting method than can munge Alert data and use stats functions on it
    - This includes a way to reset the “count” monthly/quarterly/weekly/etc (more on this later)

### SignalFlow Alert Minutes Example:
```
filter_ = filter('sf_environment', '*') and filter('sf_service', 'adservice') and filter('sf_kind', 'SERVER', 'CONSUMER') and (not filter('sf_dimensionalized', '*')) and (not filter('sf_serviceMesh', '*'))

A = data('spans.count', filter=filter_ and filter('sf_error', 'false'), rollup='rate').sum().publish(label='Success', enable=False)

B = data('spans.count', filter=filter_, rollup='rate').sum().publish(label='All Traffic', enable=False)

C = combine(100*((A if A is not None else 0)/B)).publish(label='Success Rate %')



constant = const(30)

detect(when(C < 98, duration("20s")), off=when(constant < 100, duration("35s")), mode='split').publish('Success Ratio Detector')
```

#### What are we doing here?
1. Define a filter: We’re using APM data so this filter is mostly just targeting down to a specific service “adservice”
2. Create our “Success Rate” (the inverse of error rate) so we can alert if we go below that number.
    - A gets ONLY successful requests
    - B gets ALL requests
    - C makes the Success Rate
3. Make our detector for Downtime Minutes (Minutes below Success Ratio threshold). This gets weird
    - Make a constant value (could be anything). We use this to turn off the detector if it has been on for more than 50 seconds.
    - Detector triggers when Success Rate (C) is below 95%
      - Use the off= setting along with the mode=’split’ setting to reset the detector if two conditions are met. 
        1. Detector is currently Triggered
        2. Check if constant has been less than 100 for 50 seconds

Essentially we have made an alert that will fire once every minute that the metric is breaching alertable threshold.

### SignalFlow Charting Alert Minutes Against Monthly Budget:
```
## Chart based on detector firing
A = alerts(detector_name='THIS IS MY DETECTOR NAME').count().publish(label='A', enable=False)
alert_stream = (A).sum().publish(label="alert_stream")

downtime = alert_stream.sum(cycle='month', partial_values=True).fill().publish(label="Downtime Minutes")

## 99% uptime is roughly 438 minutes
budgeted_minutes = const(438)

Total = (budgeted_minutes - downtime).fill().publish(label="Available Budget")
```

#### What are we doing here?
1. Define a metric stream from the Detector we created before.
    - Take that alert stream and sum it. We want all the minutes!
2. Create your “downtime minutes” stream 
    - Sum the summed alert stream with a cycle= of month/week/etc and allow partial_values just in case.
    - Use fill() to fill any empty data points with the last value
3. Create a constant for the number of minutes in our “error budget” or “downtime budget”
4. Create Total Available Budget
    - Subtract downtime stream from budgeted minutes constant value
    - Use fill() to fill any empty data points with the last value




## Notes:
Setting up Downtime Minutes alerts can be fiddly. 
  - Duration to trigger and Duration to reset in the alert for Alert Minutes are codependent variables. Changing one requires changing the other.
    - I.E. Alert if value below X for 20 seconds requires off= setting to be ~30 seconds
  - This can be a point of argument from teams that their alert “only breached for 20 seconds out of the minute!” or similar.    
