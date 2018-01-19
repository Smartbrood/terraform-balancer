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

    depends_on = ["aws_alb_listener.private"]
}
