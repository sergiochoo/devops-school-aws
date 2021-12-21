variable "region" {
  description = "AWS region we use"
  default     = "eu-central-1"
  type        = string
}

variable "ssh_key" {
  default     = "~/.ssh/id_rsa.pub"
  description = "Default pub key"
}

variable "ssh_priv_key" {
  default     = "~/.ssh/id_rsa"
  description = "Default private key"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "env" {
  default = "dev"
}

variable "public_subnet_cidrs" {
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}

variable "private_subnet_cidrs" {
  default = [
    "10.0.11.0/24",
    "10.0.22.0/24",
    "10.0.33.0/24"
  ]
}

variable "ec2_wordpress_asg_desired_capacity" {
  type    = number
  default = "2"
}

variable "ec2_wordpress_asg_min_capacity" {
  type    = number
  default = "1"
}

variable "ec2_wordpress_asg_max_capacity" {
  type    = number
  default = "2"
}

variable "ec2_instance_type" {
  type    = string
  default = "t2.micro"
}

variable "db_name" {
  type    = string
  default = "wordpress_db"
}

variable "db_username" {
  type    = string
  default = "wordpress"
}
