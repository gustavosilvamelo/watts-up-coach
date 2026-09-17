variable "instance_profile_arn" {
  description = "ARN of the AWS IAM instance profile to register in Databricks."
  type        = string
}

variable "bucket_name" {
  description = "S3 bucket name to expose as a Unity Catalog external location."
  type        = string
}

variable "uc_metastore_id" {
  description = "Unity Catalog metastore ID."
  type        = string
}
