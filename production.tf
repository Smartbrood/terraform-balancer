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

    depends_on = ["aws_alb_listener.production"]
}

resource "aws_alb_target_group" "production" {
    name        = "production"
    port        = 80
    protocol    = "HTTP"
    vpc_id      = "${module.vpc.values["vpc"]}"
    tags        = "${var.tags}"
} 

resource "aws_alb" "production" {
    name                 = "production"
    internal             = false
    security_groups      = ["${module.security_group.id}"]
    subnets              = [
                              "${module.vpc.values["public_subnet_a"]}",
                              "${module.vpc.values["public_subnet_b"]}",
                              "${module.vpc.values["public_subnet_c"]}"
                           ]
    tags                 = "${var.tags}"
}

resource "aws_alb_listener" "production" {
    load_balancer_arn   = "${aws_alb.production.arn}"
    port                = "80"
    protocol            = "HTTP"

    default_action {
        target_group_arn = "${aws_alb_target_group.production.arn}"
        type             = "forward"
    }
}
