# Synthetic Browser Check - Login, Navigate, Validate Example
This Terraform configuration sets up a synthetic browser test to verify the login process and navigation within an application. It demonstrates how to log in with a username and password, navigate to specific pages, and validate the presence of certain text and elements on the page.

## Synthetic Browser Test

The example test is designed to demonstrate how to login with a username and password, navigate using a specific page element, and validate the correct data was displayed on the page afterwards. 
Specifically it uses a service account with a username and password to log in to Splunk Observability, navigate to the APM section, and validate the text on the screen which confirms there is APM data in our environment. 

This is a contrived example using Splunk Observability only due to the audience of this repository.
  - For for more information on selectors and how to find the correct ones when building off this example check out this [Splunk Lantern article](https://lantern.splunk.com/Observability/UCE/Proactive_response/Improve_User_Experiences/Running_Synthetics_browser_tests/Selectors_for_multi-step_browser_tests)!

## Required Setup

1. **Update Environment Variables**: The following [global variables](https://docs.splunk.com/observability/en/synthetics/test-config/global-variables.html) are **REQUIRED** to run the included API test. 
- `service_acct_email`: A Splunk Observability service account's e-mail address
- `service_acct_password`: A Splunk Observability service account's password (Read permissions for safety)
2. **Adjust URL for Splunk Observability**: Adjust the url for your domain or realm (E.G. `https://app.us1.signalfx.com`) to this test

## Transaction Steps Details:

**Open the Login Page Transaction:**
Uses the `go_to_url` to access Splunk Observability.

**Enter Credentials Transaction:**
- **Enter Username**: Uses the `enter_value` action with an `id` selector to input the username stored in `service_acct_email`.
- **Enter Password**: Uses the `enter_value` action with an `id` selector to input the password stored in `service_acct_password`.

**Complete User Login Transaction:**
- **Signin**: Clicks the login button using a `css` selector with the `click_element` action. This step initiates the login process and waits for navigation.
- **View O11y Home Page**: Asserts the presence of the text `Home` on the page to confirm successful login.

**Load Log Observer Page Transaction:**
- **Click to Open APM Page**: Navigates to the APM section by clicking the appropriate menu item using a `css` selector with the `click_element` action.
- **View APM Page**: Asserts the presence of the text `Search for service` to ensure the page loaded correctly and APM data exists in the environment. This text will not load otherwise.

**Confirm Data Loaded Transaction:**
- **Verify Graph Visualization Rendered**: Uses the `assert_element_visible` action to check that the graph visualizations are correctly rendered on the page using `css` selectors.

