variable "environment" {
  default = "develop"
}
variable "region" {
    default = "ap-northeast-1"
}
variable "project" {}
variable "owner" {}
variable "access_key" {}
variable "secret_key" {}
variable "public_key" {}

provider "aws" {
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    region = "${var.region}"
}