variable "realm" {
  description = "the O11y realm"
  type        = string
  default     = "us1"
}

variable "access_token" {
  description = "the O11y access token, with API permissions enabled"
  type        = string
}

variable "custom_dimension" {
  description = "Dimension to filter the dashboard by"
  type = string
  default = "customer"
}

variable "username" {
  description = "the O11y Cloud username. Example: 'username@splunk.com'"
  type        = string
}

variable "dashboard_group" {
  description = "the O11y dashboard group"
  type        = string
}

variable "dashboard_name" {
  description = "the O11y dashboard name"
  default     = "CI/CD - Pipeline"
  type        = string
}

variable "event_feed_chart_name" {
  description = "The event feed chart name"
  default     = "Event Feed"
  type        = string

}

variable "log_observer_connect_connection" {
  description = "The Splunk Enterprise/Cloud endpoint to federate logs from"
  type        = string
}

variable "log_observer_connect_index" {
  description = "The Splunk Enterprise/Cloud index. Can be more than one."
  type        = string
}

variable "push_event_name" {
  description = "The event name to push to the event feed"
  default     = "canary push event"
  type        = string
}