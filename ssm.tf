resource "aws_ssm_parameter" "db_name" {
  name        = format("/%s/db-server/name", var.env)
  description = "Database name for wordpress"
  type        = "String"
  value       = var.db_name
}

resource "aws_ssm_parameter" "db_username" {
  name        = format("/%s/db-server/username", var.env)
  description = "Database username to be created in $db_name database"
  type        = "String"
  value       = var.db_username
}

resource "aws_ssm_parameter" "db_password" {
  name        = format("/%s/db-server/password", var.env)
  description = "Database password for $db_username"
  type        = "SecureString"
  value       = var.db_password
}
