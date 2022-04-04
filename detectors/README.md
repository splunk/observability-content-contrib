# General Recommendations for Detector Content for Reuse

There are many customer use cases for detectors, and any detector which provides
insight to customers isn't wrong. There are some patterns we have found which
work well in Splunk Observability and encourage content reuse.

1. **Noun-centric** : While each customer environment is different, frequently their
applications are composed of common software components/platforms. detectors
which are oriented to understanding those common software components tend to be
more reusable than detectors which are related to processes (which tend to vary
from customer to customer).

1. **Instances and Aggregates** : Customers typically need to see the "forest" and
the "trees". The way we typically implement this is to define instance and
aggregate views. In addition to being generally useful to customers, these
views are used when promoting a detector set to Navigator Views.

  * **Aggregate views** focus on enabling customers to identify which particular
  instances are outliers. Frequently the information presented in these
  detectors is aggregated to the instance as there is instance-level detail to
  enable users to further isolate the problem. An example would be showing the
  maximum utilization of all filesystems for a host in the aggregate view.
  Knowing that a host has a filesystem at 97% utilization would be enough
  information for a user to identify that host as an outlier and then further
  investigate which specific filesystem was approaching it's limit.

  * **Instance views** focus on enabling customers to identify the specific
  problem related to the instance. So for instance breaking out the filesystem
  utilization metrics by filesystem so that the user knows exactly what
  resource is approaching exhaustion.

3. **External KPIs** :

4. **Internal KPIs** :

5. **Detector Variables** :
