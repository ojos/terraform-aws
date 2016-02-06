variable "s3_acl" {
  default = "private"
}

resource "aws_s3_bucket" "default" {
    bucket = "${var.project}-${var.environment}"
    acl = "${var.s3_acl}"

    tags {
        Name = "${var.environment}"
    }

    policy = "{\"Statement\":[{\"Effect\":\"Deny\",\"Principal\":\"*\",\"Action\":\"s3:*\",\"Resource\":\"arn:aws:s3:::${var.project}-${var.environment}/*\",\"Condition\":{\"NotIpAddress\":{\"aws:SourceIp\":\"${aws_eip.default.public_ip}\"}}}]}"
}
