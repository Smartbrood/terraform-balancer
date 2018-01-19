data "template_file" "balancer" {
    template = "${file("${path.module}/templates/ecs_container_definition_balancer.json.tpl")}"

    vars {
        PRIVATE_ALB = "${aws_alb.private.dns_name}"
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
        target_group_arn = "${aws_alb_target_group.public.arn}"
        container_name = "balancer"
        container_port = 80
    }

    depends_on = ["aws_alb_listener.public"]
}
