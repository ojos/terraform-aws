variable "elasticache_type" {
    default = "cache.t2.micro"
}

variable "elasticache_engine" {
    default = "redis"
}

variable "elasticache_engine_version" {
    default = "2.8.21"
}


variable "elasticache_port" {
    default = 6379
}

variable "elasticache_num_cache_nodes" {
    default = 1
}

variable "elasticache_maintenance_window" {
    default = "Mon:02:00-Mon:03:00"
}

variable "elasticache_parameter_family" {
    default = "redis2.8"
}
 

resource "aws_elasticache_cluster" "default" {
    cluster_id = "${var.environment}"
    engine = "${var.elasticache_engine}"
    engine_version = "${var.elasticache_engine_version}"
    node_type = "${var.elasticache_type}"
    port = "${var.elasticache_port}"
    num_cache_nodes = "${var.elasticache_num_cache_nodes}"
    security_group_ids = ["${aws_security_group.default.id}"]
    subnet_group_name  = "${aws_elasticache_subnet_group.default.id}"
    parameter_group_name = "${aws_elasticache_parameter_group.default.id}"
    maintenance_window = "${var.elasticache_maintenance_window}"
    apply_immediately = true
    tags {
        Name = "${var.environment}"
    }
}

resource "aws_elasticache_parameter_group" "default" {
    name = "${var.environment}"
    family = "${var.elasticache_parameter_family}"
    description = "${var.environment} param group"
}

resource "aws_elasticache_subnet_group" "default" {
    name = "${var.environment}"
    description = "${var.environment} subnet group"
    subnet_ids = ["${aws_subnet.default-a.id}", "${aws_subnet.default-c.id}"]
}
