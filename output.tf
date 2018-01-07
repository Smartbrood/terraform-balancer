output "data_source_values" {
  value = "${module.ecs.data_source_values}"
}

output "balancer_dns_name" {
  value = "${aws_alb.balancer.dns_name}"
}
