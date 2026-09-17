output "instance_profile_arn" {
  description = "ARN of the IAM instance profile to register in Databricks."
  value       = aws_iam_instance_profile.databricks_s3.arn
}

output "role_arn" {
  description = "ARN of the IAM role."
  value       = aws_iam_role.databricks_s3.arn
}
