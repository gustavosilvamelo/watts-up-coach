output "s3_bucket_name" {
  description = "Name of the created S3 intake bucket."
  value       = module.s3_intake.bucket_name
}

output "instance_profile_arn" {
  description = "ARN of the IAM instance profile registered in Databricks."
  value       = module.iam_databricks.instance_profile_arn
}

output "uc_external_location_name" {
  description = "Name of the Unity Catalog external location pointing to the S3 bucket."
  value       = module.databricks_s3.external_location_name
}

output "secret_scope_name" {
  description = "Name of the Databricks secret scope created for API keys."
  value       = module.secret_scope.scope_name
}
