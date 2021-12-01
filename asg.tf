resource "aws_key_pair" "wordpress" {
  key_name   = "wordpress-keypairs"
  public_key = file(var.ssh_key)
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

locals {
  credentials = {
    db_name        = aws_ssm_parameter.db_name.value
    db_username    = aws_ssm_parameter.db_username.value
    db_password    = aws_ssm_parameter.db_password.value
    db_host        = aws_db_instance.mysql.endpoint
    file_system_id = aws_efs_file_system.wordpress_fs.id
  }
}
resource "aws_launch_template" "wordpress_lt" {
  name          = "wordpress_lt"
  description   = "Launch Template for the WordPress instances"
  image_id      = data.aws_ami.latest_amazon_linux.id
  instance_type = var.ec2_instance_type
  key_name      = aws_key_pair.wordpress.key_name
  user_data     = base64encode(templatefile("./data/user_data.sh", local.credentials))

  iam_instance_profile {
    name = aws_iam_instance_profile.parameter_store_profile.name
  }

  network_interfaces {
    security_groups             = [aws_security_group.wp.id]
    associate_public_ip_address = true
  }
}

resource "aws_autoscaling_group" "wordpress_asg" {
  name             = "wordpress-asg"
  desired_capacity = var.ec2_wordpress_asg_desired_capacity
  min_size         = var.ec2_wordpress_asg_min_capacity
  max_size         = var.ec2_wordpress_asg_max_capacity

  vpc_zone_identifier = aws_subnet.public_subnets[*].id
  target_group_arns   = [aws_lb_target_group.wordpress_tg.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.wordpress_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "wordpress-asg"
    propagate_at_launch = true
  }

  depends_on = [
    aws_db_instance.mysql,
  ]
}
