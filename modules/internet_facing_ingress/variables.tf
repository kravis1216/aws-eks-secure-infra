variable "globalaccelerator_name" {
  type        = string
  description = "The name of the accelerator."
}

variable "ip_address_type" {
  type    = string
  default = "IPV4"
}

variable "flow_logs_enabled" {
  description = "Enable or disable flow logs for the Global Accelerator."
  type        = bool
  default     = false
}

variable "flow_logs_s3_bucket" {
  description = "The name of the S3 Bucket for the Accelerator Flow Logs. Required if `var.flow_logs_enabled` is set to `true`."
  type        = string
  default     = null
}

variable "flow_logs_s3_prefix" {
  description = "The Object Prefix within the S3 Bucket for the Accelerator Flow Logs. Required if `var.flow_logs_enabled` is set to `true`."
  type        = string
  default     = null
}

variable "globalaccelerator_tags" {
  type        = map(any)
  description = "Key-Value map of resource tags."
}

variable "listeners" {
  description = <<-EOF
    list of listeners to configure for the global accelerator.
    For more information, see: [aws_globalaccelerator_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/globalaccelerator_listener).
  EOF
  type = list(object({
    client_affinity = string
    port_ranges = list(object({
      from_port = number
      to_port   = number
    }))
    protocol = string
  }))
  default = []
}
