# Get Rum Urls

This script will return all RUM urls present in Splunk Observability Cloud.
The script expects you to provide both the application and environment you want to get the urls for. These settings are required.
Use this an input to create of fine tune URL grouping rules.

## Prerequisites
This script expects both `curl` and `jq` to be installed.
This script has onoly been tested on MacOS.

## Environment Variables
This script relies on environment variables.
Set the following:

```
export REALM=<us1|eu0|eu1|...>
export APP=<name of the application in RUM>
export ENVIRONMENT=<environment used for the application>
export TOKEN=<user session token>
```

And run the script:

```
$ ./get_rum_urls.sh
REALM is set to: eu0
TOKEN is set.
APP is set.
ENVIRONMENT is set.
Script continues with REALM=eu0, APP=online-boutique-eu-store, ENVIRONMENT=online-boutique-eu (TOKEN value hidden).
https://online-boutique-eu.splunko11y.com/
https://online-boutique-eu.splunko11y.com/cart
https://online-boutique-eu.splunko11y.com/cart/<??>
https://online-boutique-eu.splunko11y.com/cart/checkout
https://online-boutique-eu.splunko11y.com/product/<??>
```
By default, the script shows some information before the urls are printed.

If you just want to get the list of urls output. Redirect stderr like this:
```
$ ./get_rum_urls.sh 2> /dev/null
https://online-boutique-eu.splunko11y.com/
https://online-boutique-eu.splunko11y.com/cart
https://online-boutique-eu.splunko11y.com/cart/<??>
https://online-boutique-eu.splunko11y.com/cart/checkout
https://online-boutique-eu.splunko11y.com/product/<??>
```
