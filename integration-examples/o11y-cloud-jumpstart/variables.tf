variable "access_token" {
  description = "Splunk Access Token"
}

variable "realm" {
  description = "Splunk Realm"
}

variable "o11y_prefix" {
  type        = string
  description = "Detector Prefix"
  default     = "[Splunk]"
}
