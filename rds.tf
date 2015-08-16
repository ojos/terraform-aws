variable "rds_storage" {
    default = 10
}

variable "rds_engine" {
    default = "mysql"
}

variable "rds_engine_version" {
    default = "5.6.23"
}

variable "rds_type" {
    default = "db.t2.micro"
}

variable "rds_password" {
    default = "password"
}

variable "rds_multi_az" {
    default = false
}

variable "rds_publicly_accessible" {
    default = true
}

variable "rds_storage_type" {
    default = "gp2"
}

variable "rds_backup_window" {
    default = "02:00-03:00"
}

variable "rds_maintenance_window" {
    default = "Mon:03:00-Mon:03:30"
}

variable "rds_parameter_family" {
    default = "mysql5.6"
}
 

resource "aws_db_instance" "default" {
    identifier = "${var.environment}"
    allocated_storage = "${var.rds_storage}"
    engine = "${var.rds_engine}"
    engine_version = "${var.rds_engine_version}"
    instance_class = "${var.rds_type}"
    storage_type = "${var.rds_storage_type}"
    # iops = 1000
    name = "${var.project}"
    username = "${var.project}"
    password = "${var.rds_password}"
    availability_zone = "${var.region}c"
    multi_az = "${var.rds_multi_az}"
    vpc_security_group_ids = ["${aws_security_group.default.id}"]
    db_subnet_group_name = "${aws_db_subnet_group.default.id}"
    parameter_group_name = "${aws_db_parameter_group.default.id}"
    publicly_accessible = "${var.rds_publicly_accessible}"
    backup_window = "${var.rds_backup_window}"
    maintenance_window = "${var.rds_maintenance_window}"
    apply_immediately = true
}

resource "aws_db_subnet_group" "default" {
    name = "${var.environment}"
    description = "${var.environment} subnet group"
    subnet_ids = ["${aws_subnet.default-a.id}", "${aws_subnet.default-c.id}"]
}

resource "aws_db_parameter_group" "default" {
    name = "${var.environment}"
    family = "${var.rds_parameter_family}"
    description = "${var.environment} parameter group"

    parameter {
        name = "init_connect"
        value = "SET SESSION time_zone = CASE WHEN POSITION('rds' IN CURRENT_USER()) = 1 THEN 'UTC' ELSE 'Asia/Tokyo' END;"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "character_set_client"
        value = "utf8"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "character_set_connection"
        value = "utf8"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "character_set_database"
        value = "utf8"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "character_set_filesystem"
        value = "utf8"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "character_set_results"
        value = "utf8"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "character_set_server"
        value = "utf8"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "collation_server"
        value = "utf8_general_ci"
        apply_method = "pending-reboot"
    }
    parameter {
        name = "skip-character-set-client-handshake"
        value = 0
        apply_method = "pending-reboot"
    }
    parameter {
        name = "slow_query_log"
        value = 1
        apply_method = "pending-reboot"
    }
    parameter {
        name = "long_query_time"
        value = 0.5
        apply_method = "pending-reboot"
    }
    parameter {
        name = "max_heap_table_size"
        value = 33554432
        apply_method = "pending-reboot"
    }
    parameter {
        name = "tmp_table_size"
        value = 33554432
        apply_method = "pending-reboot"
    }
    parameter {
        name = "query_cache_size"
        value = 0
        apply_method = "pending-reboot"
    }
    parameter {
        name = "thread_cache_size"
        value = 32
        apply_method = "pending-reboot"
    }
    parameter {
        name = "innodb_lock_wait_timeout"
        value = 2
        apply_method = "pending-reboot"
    }
    parameter {
        name = "innodb_max_dirty_pages_pct"
        value = 95
        apply_method = "pending-reboot"
    }
    parameter {
        name = "slow_launch_time"
        value = 1
        apply_method = "pending-reboot"
    }
    parameter {
        name = "innodb_buffer_pool_dump_at_shutdown"
        value = 1
        apply_method = "pending-reboot"
    }
    parameter {
        name = "innodb_buffer_pool_load_at_startup"
        value = 1
        apply_method = "pending-reboot"
    }
}