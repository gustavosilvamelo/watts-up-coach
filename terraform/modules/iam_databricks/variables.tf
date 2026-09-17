variable "bucket_name" {
  description = "S3 bucket name the IAM role will have access to."
  type        = string
}

variable "databricks_account_id" {
  description = "Databricks account ID used in the IAM trust policy."
  type        = string
}
