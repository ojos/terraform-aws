variable "ec2_ami" {
  default = "ami-cbf90ecb"
}

variable "ec2_type" {
  default = "t2.micro"
}

variable "ec2_name" {
  default = "test"
}

variable "ec2_roles" {
  default = "app"
}

resource "aws_key_pair" "default" {
  key_name = "${var.environment}" 
  public_key = "${file(var.public_key)}"
}

resource "aws_instance" "default" {
    ami = "${var.ec2_ami}"
    instance_type = "${var.ec2_type}"
    vpc_security_group_ids = ["${aws_security_group.default.id}"]
    subnet_id = "${aws_subnet.default-c.id}"
    key_name = "${aws_key_pair.default.key_name}"
    tags {
        Name = "${var.ec2_name}"
        Environment = "${var.environment}"
        Project = "${var.project}"
        Roles = "${var.ec2_roles}"
        Owner = "${var.owner}"
    }
}

resource "aws_eip" "default" {
    instance = "${aws_instance.default.id}"
}