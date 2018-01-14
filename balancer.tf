data "template_file" "balancer" {
    template = "${file("${path.module}/templates/ecs_container_definition_balancer.json.tpl")}"

    vars {
        PRODUCTION = "${aws_alb.production.dns_name}"
        CANARY     = "${aws_alb.canary.dns_name}"
    }
}

resource "aws_ecs_task_definition" "balancer" {
    family                = "balancer"
    container_definitions = "${data.template_file.balancer.rendered}"
}

resource "aws_ecs_service" "balancer" {
    name            = "balancer"
    cluster         = "${var.environment}-${random_pet.this.id}"
    task_definition = "${aws_ecs_task_definition.balancer.arn}"
    desired_count   = "${var.balancer_count}"

    load_balancer {
        target_group_arn = "${aws_alb_target_group.balancer.arn}"
        container_name = "balancer"
        container_port = 80
    }

    depends_on = ["aws_alb_listener.balancer"]
}

resource "aws_alb_target_group" "balancer" {
    name        = "balancer"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "${module.vpc.values["vpc"]}"
    tags        = "${var.tags}"
} 

resource "aws_alb" "balancer" {
    name               = "balancer"
    internal           = false
    security_groups    = ["${module.security_group.id}"]
    subnets            = [
                              "${module.vpc.values["public_subnet_a"]}",
                              "${module.vpc.values["public_subnet_b"]}",
                              "${module.vpc.values["public_subnet_c"]}"
                         ]
    tags               = "${var.tags}"
}

resource "aws_alb_listener" "balancer" {
    load_balancer_arn = "${aws_alb.balancer.arn}"
    port              = "80"
    protocol          = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.balancer.arn}"
        type             = "forward"
    }
}
