  
#to create with remote state:
# terraform init -backend-config=backend_dev.tfvars
# terrafrom init -backend-config=backend_prod.tfvars

#deploy vpc
module "vpc" {
  source = "./vpc"
  vpc_cidr = "${var.vpc_cidr}"
  cidrs = "${var.cidrs}"
}


#deploy compute
module "ec2" {
    source = "./ec2"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    vpc-id = "${module.vpc.vpc-id}"
    cidrs = "${var.cidrs}"
    ec2-subnet-id  = "${module.vpc.public-sn1[0]}"  #output from vpc is list, have to manually add index
}
#ec2-subnet-id  = "${element(local.subnet[terraform.workspace], 1)}"  Used when using local
#globals with pre-defined subnet id's

#deploy storage
module "s3" {
  source = "./s3"
  project_name = "${var.project_name}"
}

output "bucketnames" {
  value = "${module.s3.bucketnames}"
}




