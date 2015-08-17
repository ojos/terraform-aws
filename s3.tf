variable "s3_acl" {
  default = "private"
}

variable "s3_index_document" {
  default = "index.html"
}

variable "s3_error_document" {
  default = "404.html"
}

resource "aws_s3_bucket" "default" {
    bucket = "${var.project}-${var.environment}"
    acl = "${var.s3_acl}"

    website {
        index_document = "${var.s3_index_document}"
        error_document = "${var.s3_error_document}"
    }

    tags {
        Name = "${var.environment}"
    }
}
