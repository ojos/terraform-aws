variable "s3_acl" {
  default = "private"
}

variable "s3_backet" {
  default = "bucket_name"
}

variable "s3_allow_ips" {
  default = {
    "0" = "xxx.xxx.xxx.xxx"
  }
}

resource "aws_s3_bucket" "default" {
    bucket = "${var.s3_backet}"
    acl = "${var.s3_acl}"

    tags {
        Name = "${var.environment}"
    }

    policy = "{\"Id\":\"Policy1463662030599\",\"Version\":\"2012-10-17\",\"Statement\":[{\"Sid\":\"Stmt1463662026920\",\"Action\":[\"s3:GetObject\"],\"Effect\":\"Deny\",\"Resource\":\"arn:aws:s3:::${bucket}/*\",\"Condition\":{\"NotIpAddress\":{\"aws:SourceIp\":[\"${join(",",s3_allow_ips)}\",\"${aws_eip.default.public_ip}\"]}},\"Principal\":\"*\"}]}"
}
