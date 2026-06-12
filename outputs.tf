output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "VPC ARN"
  value       = aws_vpc.this.arn
}

output "flow_log_id" {
  description = "VPC Flow Log ID. Empty when flow logs are disabled"
  value       = var.enable_flow_logs ? aws_flow_log.this[0].id : ""
}

output "flow_log_group_name" {
  description = "CloudWatch log group name for VPC Flow Logs. Empty when flow logs are disabled"
  value       = var.enable_flow_logs ? aws_cloudwatch_log_group.flow_logs[0].name : ""
}

output "public_subnet_ids" {
  description = "IDs of managed public subnets. Empty when subnet_auto_calculation is false"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of managed private subnets. Empty when subnet_auto_calculation is false"
  value       = aws_subnet.private[*].id
}

output "module" {
  description = "Full module outputs"
  value = {
    vpc_id              = aws_vpc.this.id
    vpc_arn             = aws_vpc.this.arn
    flow_log_id         = var.enable_flow_logs ? aws_flow_log.this[0].id : ""
    flow_log_group_name = var.enable_flow_logs ? aws_cloudwatch_log_group.flow_logs[0].name : ""
    public_subnet_ids   = aws_subnet.public[*].id
    private_subnet_ids  = aws_subnet.private[*].id
  }
}
