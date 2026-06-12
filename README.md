# Module: VPC

This module creates an AWS Virtual Private Cloud (VPC). It can run as a bare VPC
(subnets managed externally) or as a self-contained network unit that provisions
its own public/private subnets, internet gateway, and route tables.

## Features
- VPC creation with custom CIDR block
- DNS support and hostnames configuration
- CIDR block validation
- Optional managed network unit: public/private subnets across AZs, internet
  gateway, and public/private route tables (no NAT gateway, zero egress cost)
- VPC Flow Logs and default security group lockdown
- Tagging support

## Usage

Bare VPC (subnets managed as separate resources):
```hcl
module "vpc" {
  source = "../../terraform-modules/terraform-aws-vpc"

  cidr_block = "10.0.0.0/16"
}
```

Managed network unit (subnets created internally):
```hcl
module "vpc" {
  source = "../../terraform-modules/terraform-aws-vpc"

  cidr_block              = "10.0.0.0/16"
  subnet_auto_calculation = true
  availability_zones      = ["us-east-1a", "us-east-1b"]
  public_subnets          = ["10.0.0.0/20", "10.0.16.0/20"]
  private_subnets         = ["10.0.32.0/20", "10.0.48.0/20"]
}
```

## Inputs
| Name | Type | Default | Description |
|------|------|---------|-------------|
| `cidr_block` | `string` | n/a | CIDR block for the VPC |
| `enable_dns_support` | `bool` | `true` | Enable DNS support for the VPC |
| `enable_dns_hostnames` | `bool` | `true` | Enable DNS hostnames for the VPC |
| `instance_tenancy` | `string` | `"default"` | Instance tenancy (`default` or `dedicated`) |
| `enable_flow_logs` | `bool` | `true` | Enable VPC Flow Logs |
| `enable_default_sg_lockdown` | `bool` | `true` | Strip all rules from the default security group |
| `subnet_auto_calculation` | `bool` | `false` | When true, create a managed network unit (public/private subnets, IGW, route tables). When false, only the VPC is created |
| `availability_zones` | `list(string)` | `[]` | AZs for managed subnets. Used only when `subnet_auto_calculation` is true |
| `public_subnets` | `list(string)` | `[]` | CIDR blocks for managed public subnets (one per AZ). Used only when `subnet_auto_calculation` is true |
| `private_subnets` | `list(string)` | `[]` | CIDR blocks for managed private subnets (one per AZ). Used only when `subnet_auto_calculation` is true |
| `tags` | `map(string)` | `{}` | Tags to apply to created resources |

## Outputs
| Name | Description |
|------|-------------|
| `vpc_id` | VPC ID |
| `vpc_arn` | VPC ARN |
| `public_subnet_ids` | IDs of managed public subnets (empty when `subnet_auto_calculation` is false) |
| `private_subnet_ids` | IDs of managed private subnets (empty when `subnet_auto_calculation` is false) |
| `flow_log_id` | VPC Flow Log ID (empty when flow logs are disabled) |
| `module` | Full module outputs |

## Environment Variables
None

## Notes
- The `cidr_block` must be a valid IPv4 CIDR.
- Public subnets route to the internet gateway; private subnets stay local-only.
  There is no NAT gateway by design, so private subnets have no outbound internet
  access and incur zero egress cost.
- When `subnet_auto_calculation` is true, `availability_zones`, `public_subnets`,
  and `private_subnets` must be the same length (one subnet CIDR per AZ).
