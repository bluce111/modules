
/* provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
} */

locals {

  }


data "aws_ami" "amazon-linux-2" {
 most_recent = true
 owners = ["amazon"]

 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }
 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
 filter {
   name   = "architecture"
   values = ["x86_64"]
 }
}
#----------EC2-----------------
resource "aws_instance" "example1-ec2" {
#  depends_on = ["aws_security_group.terra_sg"]
  ami                         = "${data.aws_ami.amazon-linux-2.id}"
  subnet_id = "${var.ec2-subnet-id}"
  associate_public_ip_address = true
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  vpc_security_group_ids             = ["${aws_security_group.ec2-sg.id}"]
  user_data        = <<EOF
        #!/bin/bash
        yum -y update
        amazon-linux-extras install nginx1.12 -y
        systemctl start nginx
        EOF

  tags {
    Name = "${terraform.workspace}-example1-ec2"
  }
}

resource "aws_security_group" "ec2-sg" {
    name = "${terraform.workspace}-ec2-sg"
    description = "ec2 security group"
    vpc_id = "${var.vpc-id}"

   ingress {
       from_port = 22
       to_port = 22
       protocol = "tcp"
       cidr_blocks = [
          "0.0.0.0/0"]
   }

   ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = [
          "0.0.0.0/0"]
   }

   ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      cidr_blocks = [
          "0.0.0.0/0"]
    }

# Access from other security groups
	ingress {
	  from_port   = 0
	  to_port     = 0
	  protocol    = "-1"
	  cidr_blocks = ["${var.cidrs}"]
	}
    
    egress {
        # allow all traffic to private SN
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = [
            "0.0.0.0/0"]
    }

    tags { 
       Name = "${terraform.workspace}-example1-sg"
     }
}