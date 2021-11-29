resource "aws_db_subnet_group" "wordpress_db_subnets" {
  name       = "wordpress_db_subnets"
  subnet_ids = aws_subnet.private_subnets[*].id

  tags = {
    Name = "My WordPress DB subnet group"
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = aws_ssm_parameter.db_name.value
  username               = aws_ssm_parameter.db_username.value
  password               = aws_ssm_parameter.db_password.value
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.mysql.id]
  db_subnet_group_name   = aws_db_subnet_group.wordpress_db_subnets.name
  skip_final_snapshot    = true
}
