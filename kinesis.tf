variable "kinesis_retention_period" {
  default = 48
}

variable "kinesis_shard_count" {
  default = 1
}

resource "aws_kinesis_stream" "default" {
    name = "${var.project}-${var.environment}"
    shard_count = "${var.kinesis_shard_count}"
    retention_period = "${var.kinesis_retention_period}"
    tags {
        Name = "${var.environment}"
    }
}