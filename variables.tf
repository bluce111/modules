
variable "aws_region" {}
variable "aws_profile" {}
variable "key_name" {}
variable "project_name" {
  default = "moduletest"
}

variable "instance_type" {
    default = "t2.micro"
}

variable "vpc_cidr" {}
variable "cidrs" {
  type = "list"
}






