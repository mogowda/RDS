resource "aws_secretsmanager_secret" "mydb" {
  name                    = "rdsadmin"
  description             = "admin password"
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "secret" {
  secret_id     = aws_secretsmanager_secret.mydb.id
  secret_string = random_password.password.result
}
