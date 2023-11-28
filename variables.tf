variable "datadog_api_key" {
  type    = string
}

variable "datadog_app_key" {
  type    = string
}

variable "datadog_api_url" {
  type    = string
}

variable "application_name" {
  type        = string
  description = "Application Name"
  default     = "demo"
}

variable "datadog_site" {
  type        = string
}