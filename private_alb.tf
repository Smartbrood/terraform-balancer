resource "aws_alb_target_group" "production" {
    name        = "production"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "${module.vpc.values["vpc"]}"
    tags        = "${var.tags}"
} 

resource "aws_alb_target_group" "canary" {
    name        = "canary"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "${module.vpc.values["vpc"]}"
    tags        = "${var.tags}"
} 

resource "aws_alb" "private" {
    name                 = "private"
    internal             = false
    security_groups      = ["${module.security_group.id}"]
    subnets              = [
                              "${module.vpc.values["public_subnet_a"]}",
                              "${module.vpc.values["public_subnet_b"]}",
                              "${module.vpc.values["public_subnet_c"]}"
                           ]
    tags                 = "${var.tags}"
}

resource "aws_alb_listener" "private" {
    load_balancer_arn = "${aws_alb.private.arn}"
    port                = "80"
    protocol            = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.production.arn}"
        type             = "forward"
    }
}

resource "aws_alb_listener_rule" "canary" {
  listener_arn = "${aws_alb_listener.private.arn}"
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.canary.arn}"
  }

  condition {
    field  = "path-pattern"
    values = ["/canary/*"]
  }
}
