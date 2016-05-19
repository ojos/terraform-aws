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

    policy = "{\"Id\":\"Policy1463662030599\",\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"Stmt1463661969875\",\"Action\":\"s3:*\",\"Effect\":\"Allow\",\"Resource\":\"arn:aws:s3:::${var.s3_backet}/*\",\"Principal\":\"*\"},{\"Sid\":\"Stmt1463662026920\",\"Action\":[\"s3:GetObject\"],\"Effect\":\"Deny\",\"Resource\":\"arn:aws:s3:::${var.s3_backet}/*\",\"Condition\":{\"NotIpAddress\":{\"aws:SourceIp\":\"${aws_eip.default.public_ip}\"}},\"Principal\":\"*\"}]}"
}
