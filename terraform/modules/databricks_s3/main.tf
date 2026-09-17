resource "databricks_instance_profile" "s3" {
  instance_profile_arn = var.instance_profile_arn
}

resource "databricks_storage_credential" "s3" {
  name = "watts-up-coach-s3-credential"

  aws_iam_instance_profile {
    instance_profile_arn = databricks_instance_profile.s3.instance_profile_arn
  }
}

resource "databricks_external_location" "intake" {
  name            = "watts-up-coach-intake"
  url             = "s3://${var.bucket_name}"
  credential_name = databricks_storage_credential.s3.name
}
