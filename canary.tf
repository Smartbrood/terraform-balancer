data "template_file" "canary" {
    template = "${file("${path.module}/templates/ecs_container_definition_canary.json.tpl")}"
}

resource "aws_ecs_task_definition" "canary" {
    family                = "canary"
    container_definitions = "${data.template_file.canary.rendered}"
}

resource "aws_ecs_service" "canary" {
    name            = "canary"
    cluster         = "${var.environment}-${random_pet.this.id}"
    task_definition = "${aws_ecs_task_definition.canary.arn}"
    desired_count   = "${var.canary_count}"

    load_balancer {
        target_group_arn = "${aws_alb_target_group.canary.arn}"
        container_name = "canary"
        container_port = 80
    }

    depends_on = ["aws_alb_listener.canary"]
}

resource "aws_alb_target_group" "canary" {
    name        = "canary"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "${module.vpc.values["vpc"]}"
    tags        = "${var.tags}"
} 

resource "aws_alb" "canary" {
    name                 = "canary"
    internal             = false
    security_groups      = ["${module.security_group.id}"]
    subnets              = [
                              "${module.vpc.values["public_subnet_a"]}",
                              "${module.vpc.values["public_subnet_b"]}",
                              "${module.vpc.values["public_subnet_c"]}"
                           ]
    tags                 = "${var.tags}"
}

resource "aws_alb_listener" "canary" {
    load_balancer_arn = "${aws_alb.canary.arn}"
    port                = "80"
    protocol            = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.canary.arn}"
        type             = "forward"
    }
}
