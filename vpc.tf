variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "subnet_a_cidr" {
  default = "172.16.0.0/20"
}

variable "subnet_c_cidr" {
  default = "172.16.16.0/20"
}

resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags {
        Name = "${var.environment}"
    }
}

resource "aws_internet_gateway" "default" {
    vpc_id = "${aws_vpc.default.id}"
    tags {
        Name = "${var.environment}"
    }
}

resource "aws_subnet" "default-a" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.subnet_a_cidr}"
    availability_zone = "${var.region}a"
    tags {
        Name = "${var.environment}-a"
    }
}

resource "aws_subnet" "default-c" {
    vpc_id = "${aws_vpc.default.id}"
    cidr_block = "${var.subnet_c_cidr}"
    availability_zone = "${var.region}c"
    tags {
        Name = "${var.environment}-c"
    }
}

resource "aws_route_table" "default" {
    vpc_id = "${aws_vpc.default.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.default.id}"
    }
    tags {
        Name = "${var.environment}"
    }
}

resource "aws_route_table_association" "default-a" {
    subnet_id = "${aws_subnet.default-a.id}"
    route_table_id = "${aws_route_table.default.id}"
}

resource "aws_route_table_association" "default-c" {
    subnet_id = "${aws_subnet.default-c.id}"
    route_table_id = "${aws_route_table.default.id}"
}

resource "aws_security_group" "default" {
    name = "${var.environment}"
    description = "${var.environment} security group"
    vpc_id = "${aws_vpc.default.id}"
 
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
 
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
