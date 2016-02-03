variable "ec2_roles" {
  default = "app"
}

resource "aws_key_pair" "default" {
  key_name = "${var.project}-${var.environment}" 
  public_key = "${file(var.public_key)}"
}

resource "aws_instance" "default" {
    ami = "${var.aws_default_ec2_ami}"
    instance_type = "${var.aws_default_instance_type}"
    vpc_security_group_ids = ["${aws_security_group.default.id}"]
    subnet_id = "${aws_subnet.default-c.id}"
    key_name = "${aws_key_pair.default.key_name}"
    tags {
        Name = "${var.project}-${var.environment}"
        Environment = "${var.environment}"
        Project = "${var.project}"
        Roles = "${var.ec2_roles}"
        Owner = "${var.owner}"
    }
}

resource "aws_eip" "default" {
    instance = "${aws_instance.default.id}"
}