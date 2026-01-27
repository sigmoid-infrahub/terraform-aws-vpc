variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"

  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "cidr_block must be a valid CIDR (e.g. 10.0.0.0/16)."
  }
}

variable "enable_dns_support" {
  type        = bool
  description = "Enable DNS support for the VPC"
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames for the VPC"
  default     = false
}

variable "subnet_auto_calculation" {
  type        = bool
  description = "Enable automatic subnet management (reserved for future use)"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the VPC"
  default     = {}
}
