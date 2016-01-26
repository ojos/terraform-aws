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
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}