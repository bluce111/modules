
provider "aws" {
  region = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

terraform {
backend "s3" {}

# terraform init -backend-config=backend_dev.tfvars
# terrafrom init -backend-config=backend_prod.tfvars
}


