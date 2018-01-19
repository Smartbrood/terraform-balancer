resource "aws_alb_target_group" "public" {
    name        = "public"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "${module.vpc.values["vpc"]}"
    tags        = "${var.tags}"
} 

resource "aws_alb" "public" {
    name               = "public"
    internal           = false
    security_groups    = ["${module.security_group.id}"]
    subnets            = [
                              "${module.vpc.values["public_subnet_a"]}",
                              "${module.vpc.values["public_subnet_b"]}",
                              "${module.vpc.values["public_subnet_c"]}"
                         ]
    tags               = "${var.tags}"
}

resource "aws_alb_listener" "public" {
    load_balancer_arn = "${aws_alb.public.arn}"
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.public.arn}"
        type             = "forward"
    }
}
