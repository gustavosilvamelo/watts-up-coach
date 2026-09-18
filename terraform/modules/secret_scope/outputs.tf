output "scope_name" {
  description = "Name of the created Databricks secret scope."
  value       = databricks_secret_scope.main.name
}
