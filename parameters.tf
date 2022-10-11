resource "aws_ssm_parameter" "dbuser" {
  name        = "/Wordpress/DBUser"
  type        = "SecureString"
  value       = "Replaceme"
  description = "Database user"
}


resource "aws_ssm_parameter" "dbname" {
  name        = "/Wordpress/DBName"
  type        = "SecureString"
  value       = "Replaceme"
  description = "Database name"
}

resource "aws_ssm_parameter" "dbendpoint" {
  name        = "/Wordpress/DBEndpoint"
  type        = "SecureString"
  value       = "Replaceme"
  description = "Database endpoint"
}

resource "aws_ssm_parameter" "dbpassword" {
  name        = "/Wordpress/DBPassword"
  type        = "SecureString"
  value       = "Replaceme"
  description = "Database password"
}

resource "aws_ssm_parameter" "dbrootpassword" {
  name        = "/Wordpress/DBRootPassword"
  type        = "SecureString"
  value       = "Replaceme"
  description = "Database root password"
}

