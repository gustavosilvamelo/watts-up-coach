terraform {
  required_version = ">= 1.8.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

provider "databricks" {
  host       = var.databricks_host
  account_id = var.databricks_account_id
}

module "s3_intake" {
  source      = "./modules/s3_intake"
  bucket_name = var.s3_bucket_name
  aws_region  = var.aws_region
}

module "iam_databricks" {
  source                  = "./modules/iam_databricks"
  bucket_name             = var.s3_bucket_name
  databricks_account_id   = var.databricks_account_id
}

module "databricks_s3" {
  source               = "./modules/databricks_s3"
  instance_profile_arn = module.iam_databricks.instance_profile_arn
  bucket_name          = var.s3_bucket_name
  uc_metastore_id      = var.uc_metastore_id

  depends_on = [module.iam_databricks]
}

module "secret_scope" {
  source     = "./modules/secret_scope"
  scope_name = var.secret_scope_name
}
