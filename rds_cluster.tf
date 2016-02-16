variable "rds_cluster_password" {
    default = "password"
}

variable "rds_cluster_preferred_backup_window" {
    default = "02:00-03:00"
}

variable "rds_cluster_preferred_maintenance_window" {
    default = "mon:03:00-mon:03:30"
}

variable "rds_cluster_instance_class" {
    default = "db.r3.large"
}

resource "aws_rds_cluster" "default" {
    cluster_identifier = "${var.project}-${var.environment}"
    availability_zones = ["${var.aws_default_region}a","${var.aws_default_region}c"]
    database_name = "${var.project}${var.environment}"
    master_username = "${var.project}"
    master_password = "${var.rds_cluster_password}"
    vpc_security_group_ids = ["${aws_security_group.default.id}"]
    db_subnet_group_name = "${aws_db_subnet_group.default.id}"
    preferred_backup_window = "${var.rds_cluster_preferred_backup_window}"
    preferred_maintenance_window = "${var.rds_cluster_preferred_maintenance_window}"
    apply_immediately = true
}

resource "aws_db_subnet_group" "default" {
    name = "${var.project}-${var.environment}"
    description = "${var.project}-${var.environment} subnet group"
    subnet_ids = ["${aws_subnet.default-a.id}", "${aws_subnet.default-c.id}"]
}

resource "aws_rds_cluster_instance" "writer" {
  count = 1
  identifier = "${var.environment}-a"
  cluster_identifier = "${aws_rds_cluster.default.id}"
  instance_class = "${var.rds_cluster_instance_class}"
  db_subnet_group_name = "${aws_db_subnet_group.default.id}"
}

resource "aws_rds_cluster_instance" "reader" {
  count = 1
  identifier = "${var.environment}-b"
  cluster_identifier = "${aws_rds_cluster.default.id}"
  instance_class = "${var.rds_cluster_instance_class}"
  db_subnet_group_name = "${aws_db_subnet_group.default.id}"
}

resource "aws_db_parameter_group" "default" {
    name = "${var.project}-${var.environment}"
    family = "${var.rds_parameter_family}"
    description = "${var.project}-${var.environment} parameter group"

    parameter {
        name = "init_connect"
        value = "SET NAMES utf8mb4;"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "character_set_client"
        value = "utf8mb4"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "character_set_connection"
        value = "utf8mb4"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "character_set_results"
        value = "utf8mb4"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "character_set_server"
        value = "utf8mb4"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "collation_connection"
        value = "utf8mb4_general_ci"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "innodb_file_format"
        value = "Barracuda"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "innodb_large_prefix"
        value = 1
        apply_method = "pending-reboot"
    }
}


