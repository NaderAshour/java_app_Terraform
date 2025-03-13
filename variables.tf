variable "aws_vpc" {
  default = "vpc-032e38306dfed1283"
}

variable "db_username" {
  description = "The username for the RDS instance"
  type        = string
  default = "admin"
}

variable "db_password" {
  description = "The password for the RDS instance"
  type        = string
  sensitive   = true
  default = "admin123"
}
variable "instance_type" {
  default = "t3.micro"
}
variable "image_id" {
  default = "ami-0298982da8499a634"
}
variable "igw_id" {
  default = "igw-07c88e9ba52c6666d"
}