output "external_location_name" {
  description = "Name of the Unity Catalog external location."
  value       = databricks_external_location.intake.name
}

output "external_location_url" {
  description = "S3 URL exposed by the external location."
  value       = databricks_external_location.intake.url
}
