
#locals {}

data "aws_availability_zones" "available" {}

#-------------VPC-----------
resource "aws_vpc" "vpc-example1" {
  cidr_block     = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name = "${terraform.workspace}-vpc"
  }
}

#-------internet gateway---------

resource "aws_internet_gateway" "example1-igw" {
    vpc_id = "${aws_vpc.vpc-example1.id}"
    tags {
    Name = "${terraform.workspace}-igw"
  }
}

#--------subnets--------------
resource "aws_subnet" "example1-pubsn" {
  count = 2
  vpc_id                  = "${aws_vpc.vpc-example1.id}"
  cidr_block              = "${var.cidrs[count.index]}"
  map_public_ip_on_launch = true
  availability_zone       = "${data.aws_availability_zones.available.names[count.index]}"

  tags {
    Name = "${terraform.workspace}-pubsn-${count.index}"
  }
}

#----------- Route tables------------------
resource "aws_route_table" "example1_public_rt" {
  vpc_id = "${aws_vpc.vpc-example1.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.example1-igw.id}"
  }

  tags {
    Name = "${terraform.workspace}-rt"
  }
}

# Associate the routing table to public subnet
resource "aws_route_table_association" "example1_rt_assn" {
  count = "${aws_subnet.example1-pubsn.count}"  
  subnet_id = "${aws_subnet.example1-pubsn.*.id[count.index]}"
  route_table_id = "${aws_route_table.example1_public_rt.id}"
}

/*  
#--------- ECS Instance Security group--------------

resource "aws_security_group" "example1_public_sg" {
    name = "example1_public_sg"
    description = "example1 public access security group"
    vpc_id = "${aws_vpc.example1_vpc.id}"

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

	ingress {
      from_port = 8081
      to_port = 8081
      protocol = "tcp"
      cidr_blocks = [
          "0.0.0.0/0"]
    }

# Access from other security groups
	ingress {
	  from_port   = 0
	  to_port     = 0
	  protocol    = "-1"
	  cidr_blocks = ["${var.vpc_cidr}"]
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
       Name = "example1_public_sg"
     }
}

#------------- EFS Security Group-------------
resource "aws_security_group" "efs" {
  name        = "EFS_security_sg"
  description = "Allow NFS traffic."
  vpc_id      = "${aws_vpc.example1_vpc.id}"

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    from_port   = "2049"
    to_port     = "2049"
    protocol    = "tcp"
    cidr_blocks = [
          "0.0.0.0/0"]
  }

  ingress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "tcp"
    security_groups  = ["${aws_security_group.example1_public_sg.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "EFS_security_sg"
    Terraform   = "true"
  }
}
*/
