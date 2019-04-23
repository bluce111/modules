

# create a random id
resource "random_id" "tf_bucket_id" {
byte_length = 2
count = 2
}

resource "aws_s3_bucket" "tf_code" {
  count         = 2
  bucket        = "${var.project_name}-${random_id.tf_bucket_id.*.dec[count.index]}"
  acl           = "private"
  force_destroy = true

  tags {
    Name = "tf_bucket-${count.index + 1}"
  }
}


output "bucketnames" {
value = "${join(", ", aws_s3_bucket.tf_code.*.id)}"
}

