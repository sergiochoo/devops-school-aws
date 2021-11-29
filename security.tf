resource "aws_security_group" "mysql" {
  name        = "wordpress-mysql-sg"
  description = "Database security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "wordpress-mysql-sg"
  }

  ingress {
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = ["${aws_security_group.wp.id}"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "wp" {
  name        = "wordpress-sg"
  description = "WordPress security group"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "wordpress-sg"
  }

  ingress {
    description = "SSH from VPC"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "icmp"
    from_port   = -1
    to_port     = -1
    cidr_blocks = [aws_vpc.main.cidr_block]
  }

  ingress {
    description = "WordPress access"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "efs-sg"
  description = "EFS mount target port"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "wordpress-efs-sg"
  }

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.wp.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
