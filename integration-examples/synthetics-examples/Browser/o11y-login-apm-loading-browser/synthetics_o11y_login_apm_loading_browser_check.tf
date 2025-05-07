resource "synthetics_create_browser_check_v2" "synthetics_o11y_login_apm_loading_browser_check" {
  test {
    active              = true
    automatic_retries   = 0
    device_id           = 1
    frequency           = 30
    location_ids        = ["aws-us-east-1", "aws-us-west-1"]
    name                = "APM Sanity Check"
    scheduling_strategy = "round_robin"
    start_url           = null
    url_protocol        = null
    advanced_settings {
      collect_interactive_metrics = true
      user_agent                  = null
      verify_certificates         = true
    }
    transactions {
      name = "Open the login page"
      steps {
        action               = null
        duration             = 0
        max_wait_time        = 0
        name                 = null
        option_selector      = null
        option_selector_type = null
        selector             = null
        selector_type        = null
        type                 = "go_to_url"
        url                  = "https://app.us1.signalfx.com"
        value                = null
        variable_name        = null
        wait_for_nav         = false
        wait_for_nav_timeout = 0
      }
      steps {
        action               = null
        duration             = 0
        max_wait_time        = 0
        name                 = "Enter username"
        option_selector      = null
        option_selector_type = null
        selector             = "email"
        selector_type        = "id"
        type                 = "enter_value"
        url                  = null
        value                = "{{env.service_acct_email}}"
        variable_name        = null
        wait_for_nav         = false
        wait_for_nav_timeout = 50
      }
      steps {
        action               = null
        duration             = 0
        max_wait_time        = 0
        name                 = "Enter password"
        option_selector      = null
        option_selector_type = null
        selector             = "password"
        selector_type        = "id"
        type                 = "enter_value"
        url                  = null
        value                = "{{env.service_acct_password}}"
        variable_name        = null
        wait_for_nav         = false
        wait_for_nav_timeout = 50
      }
    }
    transactions {
      name = "Complete user login"
      steps {
        action               = null
        duration             = 0
        max_wait_time        = 0
        name                 = "Signin"
        option_selector      = null
        option_selector_type = null
        selector             = "button.login-button"
        selector_type        = "css"
        type                 = "click_element"
        url                  = null
        value                = null
        variable_name        = null
        wait_for_nav         = true
        wait_for_nav_timeout = 2000
      }
      steps {
        action               = null
        duration             = 0
        max_wait_time        = 10000
        name                 = "View O11y Home Page"
        option_selector      = null
        option_selector_type = null
        selector             = null
        selector_type        = null
        type                 = "assert_text_present"
        url                  = null
        value                = "Home"
        variable_name        = null
        wait_for_nav         = false
        wait_for_nav_timeout = 0
      }
    }
    transactions {
      name = "Load APM page"
      steps {
        action               = null
        duration             = 0
        max_wait_time        = 0
        name                 = "Click to open APM page"
        option_selector      = null
        option_selector_type = null
        selector             = "[data-test=apm-nav-menu]"
        selector_type        = "css"
        type                 = "click_element"
        url                  = null
        value                = null
        variable_name        = null
        wait_for_nav         = true
        wait_for_nav_timeout = 2000
      }
      steps {
        action               = null
        duration             = 0
        max_wait_time        = 10000
        name                 = "View APM Page"
        option_selector      = null
        option_selector_type = null
        selector             = null
        selector_type        = null
        type                 = "assert_text_present"
        url                  = null
        value                = "Search for service"
        variable_name        = null
        wait_for_nav         = false
        wait_for_nav_timeout = 0
      }
    }
    transactions {
      name = "Confirm data loaded"
      steps {
        action               = null
        duration             = 0
        max_wait_time        = 10000
        name                 = "Wait for data loaded"
        option_selector      = null
        option_selector_type = null
        selector             = "[data-test=\"apm-automation-legend-p99\"]"
        selector_type        = "css"
        type                 = "assert_element_visible"
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
        name                 = "Verify graph visualization rendered"
        option_selector      = null
        option_selector_type = null
        selector             = "[class=rv-xy-plot__inner]"
        selector_type        = "css"
        type                 = "assert_element_visible"
        url                  = null
        value                = null
        variable_name        = null
        wait_for_nav         = false
        wait_for_nav_timeout = 0
      }
    }
  }
}
