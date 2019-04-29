output "public-sn1" {
  value = "${aws_subnet.example1-pubsn.*.id}"
}

output "vpc-id" {
  value = "${aws_vpc.vpc-example1.id}"
}
output "cidrs" {
  value = "$[{var.cidrs.*.id}]"
}