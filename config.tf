variable "environment" {
  default = "develop"
}
variable "project" {}
variable "owner" {}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "aws_default_region" {}
variable "aws_default_availability_zone" {}
variable "aws_default_security_group" {}
variable "aws_default_subnet_id" {}
variable "aws_default_vpc_id" {}
variable "aws_default_username" {}
variable "aws_default_instance_type" {}
variable "aws_default_ec2_ami" {}
variable "public_key" {}

provider "aws" {
    access_key = "${var.aws_access_key_id}"
    secret_key = "${var.aws_secret_access_key}"
    region = "${var.aws_default_region}"
}