variable "api_token" {
  description = "Splunk API Token"
}

variable "realm" {
  description = "Splunk Realm"
}

variable "o11y_prefix" {
  type        = string
  description = "Detector Prefix"
  default     = "[Splunk]"
}
