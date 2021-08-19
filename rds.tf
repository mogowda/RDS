resource "random_password" "password" {
  length  = 16
  special = true
}
#RDS Creation
resource "aws_db_instance" "mydb2" {
  allocated_storage        = "20" # gigabytes
  backup_retention_period  = "7"   # in days
  db_subnet_group_name     = "default-vpc-436fa728"
  engine                   = "mysql"
  engine_version           = "8.0.25"
  identifier               = "mydb2"
  instance_class           = "db.t2.micro"
  availability_zone        = "ap-south-1a"
  multi_az                 = "false"
  name                     = "mydb2"
  parameter_group_name     = "default.mysql8.0"
  password                 = random_password.password.result
  port                     = "3306"
  publicly_accessible      = "true"
  storage_encrypted        = "false" # you should always do this
  storage_type             = "gp2"
  username                 = "admin"
  vpc_security_group_ids   = ["${aws_security_group.mydb2.id}"]
  skip_final_snapshot      = "true"
}

resource "aws_security_group" "mydb2" {
  name = "mydb2"
}

resource "aws_security_group_rule" "allow-http" {
    type      = "ingress" 
    from_port = "3306"
    to_port = "3306"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.mydb2.id 
  }

  # Allow all outbound traffic.
  resource "aws_security_group_rule" "allow-all"{
    type      = "egress" 
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    security_group_id = aws_security_group.mydb2.id 
  }
