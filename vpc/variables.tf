
variable "vpc-name" {
    default = "dev"
}
variable "vpc_cidr" {
    description = "cidr block range of vpc"
}

variable "cidrs" {
  type = "list"
}