variable "iam_server_certificate_body" {
  default = ""
}

variable "iam_server_certificate_private_key" {
  default = ""
}

resource "aws_iam_server_certificate" "default" {
  name = "${var.project}-${var.environment}"
  certificate_body = "${file(${var.iam_server_certificate_body})}"
  private_key = "${file(${var.iam_server_certificate_private_key})}"
}