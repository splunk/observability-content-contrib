# Synthetic Browser Check - Purchase Checkout Example
This synthetic browser check provides an example test for complex user flows (in this case checkout) on an e-commerce website ([HipsterShop](https://github.com/signalfx/microservices-demo/)). It simulates the user journey from browsing products to completing an order, ensuring critical functionalities are working correctly.
The test and it's configuration are included in this directory:
- [`synthetics_hipstershop_order_completion_browser_check.tf`](./synthetics_hipstershop_order_completion_browser_check.tf) 
    - Uses the [Splunk Synthetics Terraform provider](https://registry.terraform.io/providers/splunk/synthetics/latest/docs)

## Synthetic Browser Test
The configuration leverages Terraform's synthetics browser check resource to automate interactions such as navigating URLs, selecting products, adding them to the cart, and placing orders. This example can be adapted for testing similar flows in your own applications.

- For for more information on selectors and how to find the correct ones when building off this example check out this [Splunk Lantern article](https://lantern.splunk.com/Observability/UCE/Proactive_response/Improve_User_Experiences/Running_Synthetics_browser_tests/Selectors_for_multi-step_browser_tests)!

## Required Setup

1. **Replace the hipstershop URL in the test with your URL**: Modify the placeholder value in this test from `https://my-hipstershop-demo-url-should-go-here.com/` to the URL for your hipstershop instance url

## Transaction Steps Details:

**Home Transaction:**
Uses the go_to_url action to navigate to the Hipstershop demo site's URL. 

**Shop Transaction:**
Executes JavaScript to select a random product from a predefined list and open the product's page.   

**Cart Transaction:**
Clicks the "Add to Cart" button using an `xpath` selector to locate the button.  

**Place Order Transaction:**
Step 1: Clicks the "Place order" button using an `xpath` selector.
Step 2: Waits for 20 seconds to allow for the backend to process the order.
Step 3: Asserts that the text "Order Confirmation ID" is present on the page.

**Keep Browsing Transaction:**
Clicks a button to navigate away from the order confirmation page


