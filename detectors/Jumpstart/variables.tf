variable "access_token" {
  description = "Splunk Access Token"
}

variable "realm" {
  description = "Splunk Realm"
}

variable "sfx_prefix" {
  type        = string
  description = "Detector Prefix"
  default     = "[Splunk]"
}
