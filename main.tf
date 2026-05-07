resource "aws_vpc" "this" {
  cidr_block       = var.cidr_block
  instance_tenancy = var.instance_tenancy

  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = local.resolved_tags
}

resource "aws_cloudwatch_log_group" "flow_logs" {
  count = var.enable_flow_logs ? 1 : 0

  name              = "/aws/vpc/${aws_vpc.this.id}/flow-logs"
  retention_in_days = var.flow_log_retention_days
  kms_key_id        = length(trimspace(var.flow_log_kms_key_id)) > 0 ? var.flow_log_kms_key_id : null

  tags = local.resolved_tags
}

resource "aws_iam_role" "flow_logs_role" {
  count = var.enable_flow_logs ? 1 : 0

  name_prefix = "sigmoid-vpc-flow-logs-"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.resolved_tags
}

resource "aws_iam_role_policy" "flow_logs_policy" {
  count = var.enable_flow_logs ? 1 : 0

  name = "sigmoid-vpc-flow-logs"
  role = aws_iam_role.flow_logs_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_flow_log" "this" {
  count = var.enable_flow_logs ? 1 : 0

  iam_role_arn         = aws_iam_role.flow_logs_role[0].arn
  log_destination      = aws_cloudwatch_log_group.flow_logs[0].arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = var.flow_log_traffic_type
  vpc_id               = aws_vpc.this.id

  tags = local.resolved_tags
}

resource "aws_default_security_group" "default" {
  count = var.enable_default_sg_lockdown ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = merge(local.resolved_tags, {
    Name = "${aws_vpc.this.id}-default-locked-down"
  })
}
