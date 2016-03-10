variable "s3_acl" {
  default = "private"
}

variable "s3_backet" {
  default = "bucket_name"
}

resource "aws_s3_bucket" "default" {
    bucket = "${var.s3_backet}"
    acl = "${var.s3_acl}"

    tags {
        Name = "${var.environment}"
    }

    policy = "{\"Statement\":[{\"Effect\":\"Deny\",\"Principal\":\"*\",\"Action\":\"s3:GetObject\",\"Resource\":\"arn:aws:s3:::${var.s3_backet}/*\",\"Condition\":{\"NotIpAddress\":{\"aws:SourceIp\":\"${aws_eip.default.public_ip}\"}}}]}"
}
