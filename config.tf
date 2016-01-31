variable "environment" {
  default = "develop"
}
variable "project" {}
variable "owner" {}
variable "access_key" {}
variable "secret_key" {}
variable "region" {}
variable "public_key" {}

provider "aws" {
    access_key = "${var.aws_access_key_id}"
    secret_key = "${var.aws_secret_access_key}"
    region = "${var.aws_default_region}"
}