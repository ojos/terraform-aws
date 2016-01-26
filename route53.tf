resource "aws_route53_zone" "default" {
  name = "example.co.jp"
}

resource "aws_route53_record" "default" {
  zone_id = "${aws_route53_zone.default.zone_id}"
  name = "example.co.jp"
  type = "A"

  alias {
    name = "${aws_elb.default.dns_name}"
    zone_id = "${aws_elb.default.zone_id}"
    evaluate_target_health = false
  }
}