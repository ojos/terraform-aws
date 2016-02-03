resource "aws_elb" "default" {
  name = "${var.project}-${var.environment}"
  subnets = ["${aws_subnet.default-a.id}", "${aws_subnet.default-c.id}"]
  security_groups = ["${aws_security_group.default.id}"]

  listener {
    instance_port = 8000
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  # listener {
  #   instance_port = 8000
  #   instance_protocol = "http"
  #   lb_port = 443
  #   lb_protocol = "https"
  #   ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/certName"
  # }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:8000/health_check"
    interval = 30
  }

  instances = ["${aws_instance.default.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "${var.project}-${var.environment}"
  }
}