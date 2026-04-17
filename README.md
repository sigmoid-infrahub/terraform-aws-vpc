# Module: VPC

This module creates an AWS Virtual Private Cloud (VPC) with basic networking configuration.

## Features
- VPC creation with custom CIDR block
- DNS support and hostnames configuration
- CIDR block validation
- Tagging support

## Usage
```hcl
module "vpc" {
  source = "../../terraform-modules/terraform-aws-vpc"

  cidr_block = "10.0.0.0/16"
}
```

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `cidr_block` | `string` | n/a | CIDR block for the VPC |
| `enable_dns_support` | `bool` | `true` | Enable DNS support for the VPC |
| `enable_dns_hostnames` | `bool` | `false` | Enable DNS hostnames for the VPC |
| `subnet_auto_calculation` | `bool` | `true` | Enable automatic subnet management (reserved for future use) |
| `tags` | `map(string)` | `{}` | Tags to apply to the VPC |

## Outputs
| Name | Description |
|------|-------------|
| `vpc_id` | VPC ID |
| `vpc_arn` | VPC ARN |
| `module` | Full module outputs |

## Environment Variables
None

## Notes
- The `cidr_block` must be a valid IPv4 CIDR.
- DNS support is enabled by default.
