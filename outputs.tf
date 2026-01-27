output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "VPC ARN"
  value       = aws_vpc.this.arn
}

output "module" {
  description = "Full module outputs"
  value = {
    vpc_id  = aws_vpc.this.id
    vpc_arn = aws_vpc.this.arn
  }
}
