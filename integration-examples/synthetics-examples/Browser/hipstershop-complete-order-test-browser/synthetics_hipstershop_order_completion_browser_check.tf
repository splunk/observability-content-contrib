resource "synthetics_create_browser_check_v2" "synthetics_hipstershop_order_completion_browser_check" {
  test {
    active              = true
    automatic_retries   = 0
    device_id           = 1
    frequency           = 1
    location_ids        = ["aws-us-east-1", "aws-us-west-1"]
    name                = "Hipstershop Demo - checkout test"
    scheduling_strategy = "round_robin"
    start_url           = null
    url_protocol        = null
    advanced_settings {
      collect_interactive_metrics = true
      user_agent                  = null
      verify_certificates         = true
    }
    transactions {
      name = "Home"
      steps {
        action               = null
        duration             = 0
        max_wait_time        = 0
        name                 = "Online Boutique (add your hipstershop demo URL to this step)"
        option_selector      = null
        option_selector_type = null
        selector             = null
        selector_type        = null
        type                 = "go_to_url"
        url                  = "https://my-hipstershop-demo-url-should-go-here.com/"
        value                = null
        variable_name        = null
        wait_for_nav         = false
        wait_for_nav_timeout = 0
      }
    }
    transactions {
      name = "Shop"
      steps {
        action               = null
        duration             = 0
        max_wait_time        = 0
        name                 = "Select Random Product"
        option_selector      = null
        option_selector_type = null
        selector             = null
        selector_type        = null
        type                 = "run_javascript"
        url                  = null
        value                = "var products = [\n\"OLJCESPC7Z\",\n\"2ZYFJ3GM2N\",\n\"1YMWWN1N4O\",\n\"LS4PSXUNUM\",\n\"L9ECAV7KIM\",\n\"0PUK6V6EV0\",\n\"9SIQT8TOJO\",\n\"66VCHSJNUP\",\n\"6E92ZMYYFZ\"\n]\n\nvar randomProducts = products[Math.floor(Math.random() * products.length)];\n\nwindow.open(\"{{env.hipstershop_url}}/product/\" + randomProducts, \"_self\");"
        variable_name        = null
        wait_for_nav         = true
        wait_for_nav_timeout = 2000
      }
    }
    transactions {
      name = "Cart"
      steps {
        action               = null
        duration             = 0
        max_wait_time        = 0
        name                 = "Add to cart"
        option_selector      = null
        option_selector_type = null
        selector             = "//button[contains(text(), \"Add to Cart\")]"
        selector_type        = "xpath"
        type                 = "click_element"
        url                  = null
        value                = null
        variable_name        = null
        wait_for_nav         = true
        wait_for_nav_timeout = 2000
      }
    }
    transactions {
      name = "Place Order"
      steps {
        action               = null
        duration             = 0
        max_wait_time        = 0
        name                 = "Place Order"
        option_selector      = null
        option_selector_type = null
        selector             = "//button[contains(text(), \"Place order\")]"
        selector_type        = "xpath"
        type                 = "click_element"
        url                  = null
        value                = null
        variable_name        = null
        wait_for_nav         = true
        wait_for_nav_timeout = 2000
      }
      steps {
        action               = null
        duration             = 20000
        max_wait_time        = 0
        name                 = "Wait 20 seconds"
        option_selector      = null
        option_selector_type = null
        selector             = null
        selector_type        = null
        type                 = "wait"
        url                  = null
        value                = null
        variable_name        = null
        wait_for_nav         = false
        wait_for_nav_timeout = 0
      }
      steps {
        action               = null
        duration             = 0
        max_wait_time        = 10000
        name                 = "confirm checkout"
        option_selector      = null
        option_selector_type = null
        selector             = null
        selector_type        = null
        type                 = "assert_text_present"
        url                  = null
        value                = "Order Confirmation ID"
        variable_name        = null
        wait_for_nav         = false
        wait_for_nav_timeout = 0
      }
    }
    transactions {
      name = "Keep Browsing"
      steps {
        action               = null
        duration             = 0
        max_wait_time        = 0
        name                 = "Keep Browsing"
        option_selector      = null
        option_selector_type = null
        selector             = "//a[@role='button']"
        selector_type        = "xpath"
        type                 = "click_element"
        url                  = null
        value                = null
        variable_name        = null
        wait_for_nav         = true
        wait_for_nav_timeout = 2000
      }
    }
  }
}
