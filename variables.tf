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
  default     = true
}

variable "instance_tenancy" {
  type        = string
  description = "Tenancy option for instances launched into the VPC"
  default     = "default"

  validation {
    condition     = contains(["default", "dedicated"], var.instance_tenancy)
    error_message = "instance_tenancy must be one of: default, dedicated."
  }
}

variable "enable_flow_logs" {
  type        = bool
  description = "Enable VPC Flow Logs for security auditing"
  default     = true
}

variable "flow_log_retention_days" {
  type        = number
  description = "CloudWatch log retention period for VPC Flow Logs"
  default     = 30
}

variable "flow_log_kms_key_id" {
  type        = string
  description = "KMS key ARN or ID used to encrypt the VPC Flow Logs log group. Empty uses CloudWatch default encryption"
  default     = ""
}

variable "flow_log_traffic_type" {
  type        = string
  description = "Traffic type captured by VPC Flow Logs"
  default     = "ALL"

  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.flow_log_traffic_type)
    error_message = "flow_log_traffic_type must be one of: ACCEPT, REJECT, ALL."
  }
}

variable "enable_default_sg_lockdown" {
  type        = bool
  description = "Remove all ingress and egress rules from the default security group"
  default     = true
}

variable "subnet_auto_calculation" {
  type        = bool
  description = "When true, the module creates a full managed network unit (public/private subnets across AZs, internet gateway, and route tables). When false, only the VPC is created and subnets are managed as separate resources."
  default     = false
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones to spread managed subnets across. Used only when subnet_auto_calculation is true."
  default     = []
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDR blocks for managed public subnets (one per availability zone). Used only when subnet_auto_calculation is true."
  default     = []
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDR blocks for managed private subnets (one per availability zone). Used only when subnet_auto_calculation is true."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the VPC"
  default     = {}
}

# ====================================
# Sigmoid Tags Configuration
# ====================================

variable "sigmoid_environment" {
  description = "Sigmoid environment identifier for cost allocation"
  type        = string
  default     = ""
}

variable "sigmoid_project" {
  description = "Sigmoid project identifier for cost allocation"
  type        = string
  default     = ""
}

variable "sigmoid_team" {
  description = "Sigmoid team identifier for cost allocation"
  type        = string
  default     = ""
}
