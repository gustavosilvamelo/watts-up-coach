variable "aws_region" {
  description = "AWS region where S3 bucket and IAM resources will be created."
  type        = string
  default     = "us-east-1"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket used for document intake and index persistence."
  type        = string
  default     = "watts-up-coach-docs"
}

variable "databricks_host" {
  description = "Databricks workspace URL (e.g. https://dbc-xxxxxx.cloud.databricks.com)."
  type        = string
}

variable "databricks_account_id" {
  description = "Databricks account ID (visible in account console)."
  type        = string
}

variable "uc_metastore_id" {
  description = "Unity Catalog metastore ID attached to the workspace."
  type        = string
}

variable "secret_scope_name" {
  description = "Name of the Databricks secret scope that stores API keys."
  type        = string
  default     = "watts-up-coach"
}
