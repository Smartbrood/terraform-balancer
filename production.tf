data "template_file" "production" {
    template = "${file("${path.module}/templates/ecs_container_definition_production.json.tpl")}"
}

resource "aws_ecs_task_definition" "production" {
    family                = "production"
    container_definitions = "${data.template_file.production.rendered}"
}

resource "aws_ecs_service" "production" {
    name            = "production"
    cluster         = "${var.environment}-${random_pet.this.id}"
    task_definition = "${aws_ecs_task_definition.production.arn}"
    desired_count   = "${var.production_count}"

    load_balancer {
        target_group_arn = "${aws_alb_target_group.production.arn}"
        container_name   = "production"
        container_port   = 80
    }

    depends_on = ["aws_alb_listener.private"]
}
