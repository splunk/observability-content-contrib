# General Recommendations for Dashboard Content for Reuse

There are many use cases for dashboards, and any dashboard which provides
insight may be useful to others. There are some patterns we have found which
work well in Splunk Observability and encourage content reuse.

1. **Noun-centric** : While each environment is different, frequently their
applications are composed of common software components/platforms. Dashboards
which are oriented to understanding those common software components tend to be
more reusable than dashboards which are related to processes (which tend to vary
from environment to environment).

1. **Instances and Aggregates** : Users typically need to see the "forest" and
the "trees". The way we typically implement this is to define instance and
aggregate views. In addition to being generally useful to users, these
views are used when promoting a dashboard set to Navigator Views.

  * **Aggregate views** focus on enabling users to identify which particular
  instances are outliers. Frequently the information presented in these
  dashboards is aggregated to the instance as there is instance-level detail to
  enable users to further isolate the problem. An example would be showing the
  maximum utilization of all filesystems for a host in the aggregate view.
  Knowing that a host has a filesystem at 97% utilization would be enough
  information for a user to identify that host as an outlier and then further
  investigate which specific filesystem was approaching it's limit. (NOTE: by
  convention the upper left chart in default aggregate views is a single value
  chart counting the number of instances of the aggregate)

  * **Instance views** focus on enabling users to identify the specific
  problem related to the instance. So for instance breaking out the filesystem
  utilization metrics by filesystem so that the user knows exactly what
  resource is approaching exhaustion.

3. **KPIs** provide insight into the health and availability of the platform.

  * **External KPIs** define the perceived external performance of the system.
  A good mnemonic for external responsiveness of many systems is the RED metrics,
  Rate, Errors and Duration. Measuring these attributes based on incoming
  requests/queries enables characterization of the potential impact a particular
  system has on applications which are consuming its services.

    * **Rate** measurements vary somewhat depending on the type of system. Rate
    measurements are typically reported in terms of event counts, but depending
    on the type of system rates may be expressed in terms of rate of data
    (bytes/sec). A sudden, significant change in transaction rate is a common
    alert criteria.

    * **Error** measurements inform users as to failure cases. A spike in errors
    is generally indicative of larger issues. Errors are also frequently the
    focus of detectors. Errors are generally counters.

    * **Duration** measurements inform users as to the quality of service
    delivery. General increases in duration are typically indicative of system
    load or resource exhaustion. Individually-long transactions may indicate
    a specific transaction which is not optimized.

  * **Internal KPIs** track the utilization of key platform resources. Often
  this includes basic process (CPU, memory, I/O) metrics and can include
  platform-specific resources such as queues, connections, and locks. These
  metrics should enable users to gauge the risk of resource exhaustion.

4. **Dashboard Variables** provide default filters appropriate to the data set,
typically these are the common dimension values related to the entities, for
instance dashboard will almost always have the instance identifier as the first
Dashboard Variable (generally marked as mandatory so that users are encouraged
to select a single instance as the subject of the dashboard).

5. **Resolution Invariance** should be considered where appropriate. In many
cases users will be changing the time range or resolution of their view, for
instance zooming in on the time period where errors or performance degradation
is evident. Keeping the values constant regardless of chart resolution keeps
the user's view consistent. Strategies for maintaining resolution invariance
include:

  * **Rate** based calculations are inherently invariant of resolution. For
  `Counter` and `Cumulative Counter` metrics the `Rate/Sec` rollup will convert
  counts to a rate implicitly.

  * **Statistical Rollups** like `Mean`, `Min`, `Max` are also somewhat
  invariant of time (mean does tend to average out variations). **NOTE** that
  SignalFlow provides statistical functions over periods of time as well across
  populations, so it is important to consider whether you're aggregating over
  time periods or over members of the set.

  * **Transformation** functions generally work over fixed time periods and as
  such can be invariant of resolution (provided the resolution of the data and
  the chart support the analytic)

6. **Chart Annotations** such as Title, Subtitle, Legend should be clear and
include the following information (unless it is obvious from the dashboard
context):

  * **Units** should be clear. Generally it is more efficient of screen real
  estate to state the units in the Title or Subtitle, but you can also use the
  Axis labels. The `Display Units` visualization option is another efficient
  mechanism to communicate the units within the chart data, however it is only
  evident on hover or in the data table.

  * **Scope** of the data should be defined. It is common for metrics to be
  specific to the direction (storage read/write) or to category (cpu
  user/system). If the data is filtered or could be filtered in these ways it
  should be clear (or clear that you're include all the data). Similarly, if
  the results are filtered to the `Top` results, that should be stated.

  * **Time Range** should be stated explicitly for charts which use
  `Transformation` analytics over periods of time.

7. **Chart Options** provides several options which should often be considered.

  * **Color By** may need to be set to ensure that chart data is appropriately
  differentiated by color.

  * **Data Table Columns** frequently includes dimension and property
  information along with `sf_metric` and `Plot Name`. This information is
  presented in the Data Table and also on hover and should be turned off unless
  it is obviously valuable to interpreting the data in the chart. For instance
  if you use the `Percentile` analytic you likely want to change the `Plot
  Name` to something like `p95`.

  * **Minimum Resolution** determines the lowest resolution value. For lower
  rate data high frequency calculations may not be intuitive (e.g. one event in
  a 10 second interval represents an instantaneous rate of 360 events/second,
  which might not be an intuitive presentation)

  * **No Active Metrics Found** In some cases there may be no results. If the
  metric reported is optional and the option is disabled for some instances or
  if the metric is unresolved (e.g. error % when there are no transactions
  so 0 errors / 0 transactions is simply indeterminate), then you can include
  text to clarify why there is no data (and perhaps suggest options which
  would allow the telemetry to be collected). Subtitle text can alternatively
  be used to clarify why data might not be reported.
