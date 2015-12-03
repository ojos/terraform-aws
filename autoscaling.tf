resource "aws_launch_configuration" "default" {
    name = "${var.environment}"
    image_id = "${var.ec2_ami}"
    instance_type = "${var.ec2_app_type}"
    security_groups = ["${aws_security_group.default.id}"]
    key_name = "${aws_key_pair.default.key_name}"
    associate_public_ip_address = true
}

resource "aws_autoscaling_group" "default" {
    name = "${var.environment}"
    max_size = 16
    min_size = 8
    desired_capacity = 8
    health_check_grace_period = 300
    health_check_type = "ELB"
    force_delete = true
    load_balancers = ["${aws_elb.default.name}"]
    vpc_zone_identifier = ["${aws_subnet.default-a.id}", "${aws_subnet.default-c.id}"]
    launch_configuration = "${aws_launch_configuration.default.name}"

    tag {
        key = "Name"
        value = "${var.environment}"
        propagate_at_launch = true
    }
    tag {
        key = "Environment"
        value = "${var.environment}"
        propagate_at_launch = true
    }
    tag {
        key = "Project"
        value = "${var.project}"
        propagate_at_launch = true
    }
    tag {
        key = "Roles"
        value = "app,admin,worker,scheduler"
        propagate_at_launch = true
    }
    tag {
        key = "Owner"
        value = "admin"
        propagate_at_launch = true
    }
    tag {
        key = "Start"
        value = "Auto"
        propagate_at_launch = true
    }
}

resource "aws_autoscaling_policy" "scaleout" {
    name = "${var.environment}-scale-out"
    scaling_adjustment = 4
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = "${aws_autoscaling_group.default.name}"
}

resource "aws_cloudwatch_metric_alarm" "scaleout" {
    alarm_name = "${var.environment}-scale-out-queue-length"
    metric_name = "SurgeQueueLength"
    namespace = "AWS/ELB"
    dimensions = {
        LoadBalancerName = "${aws_elb.default.name}"
    }
    comparison_operator = "GreaterThanOrEqualToThreshold"
    statistic = "Sum"
    threshold = "30"
    evaluation_periods = "2"
    period = "60"
    alarm_description = "${var.environment} scale out alarm"
    alarm_actions = ["${aws_autoscaling_policy.scaleout.arn}"]
}

resource "aws_autoscaling_policy" "scalein" {
    name = "${var.environment}-scale-in"
    scaling_adjustment = -4
    adjustment_type = "ChangeInCapacity"
    cooldown = 300
    autoscaling_group_name = "${aws_autoscaling_group.default.name}"
}

resource "aws_cloudwatch_metric_alarm" "scalein" {
    alarm_name = "${var.environment}-scale-in-queue-length"
    metric_name = "SurgeQueueLength"
    namespace = "AWS/ELB"
    dimensions = {
        LoadBalancerName = "${aws_elb.default.name}"
    }
    comparison_operator = "LessThanOrEqualToThreshold"
    statistic = "Sum"
    threshold = "0"
    evaluation_periods = "5"
    period = "60"
    alarm_description = "${var.environment} scale in alarm"
    alarm_actions = ["${aws_autoscaling_policy.scalein.arn}"]
}


