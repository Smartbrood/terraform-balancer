terraform {
    version    = "1.0.2"
}

provider "aws" {
    version    = "0.1.3"
    region     = "${var.region}"
}

provider "null" {
    version    = "1.0.0"
}

provider "random" {
    version    = "1.1.0"
}

module "key-pair" {
    source          = "./modules/terraform-aws-key-pair"
    public_key_path = "${var.public_key_path}"
}

resource "random_pet" "this" {
    length = "1"
}

module "vpc" {
    source           = "./modules/terraform-aws-vpc"
    region           = "${var.region}"
    vpc_cidr         = "10.3.0.0/16"
    public_subnet_a  = "10.3.1.0/24"
    public_subnet_b  = "10.3.2.0/24"
    public_subnet_c  = "10.3.3.0/24"
    private_subnet_a = "10.3.4.0/24"
    private_subnet_b = "10.3.5.0/24"
    private_subnet_c = "10.3.6.0/24"
    tags = "${merge(var.tags, map("Name", "${var.environment}-${random_pet.this.id}", "Environment", "${var.environment}"))}"
}

module "security_group" {
    source      = "./modules/terraform-aws-security-group"
    name        = "${var.environment}-${random_pet.this.id}"
    description = "For EC2 instances in ECS cluster"
    vpc_id      = "${module.vpc.values["vpc"]}"
    tags = "${merge(var.tags, map("Name", "${var.environment}-${random_pet.this.id}"))}"
    ingress_rules_from_any  = ["ssh-22-tcp", "https-443-tcp", "http-80-tcp"]
    egress_rules_to_any     = ["ssh-22-tcp", "https-443-tcp", "http-80-tcp"]
    ingress_rules           = ["any"]
    ingress_cidr_blocks     = ["${module.vpc.values["vpc_cidr_block"]}"]
    egress_rules            = ["any"]
    egress_cidr_blocks      = ["${module.vpc.values["vpc_cidr_block"]}"]
}

module "ecs" {
    source                = "./modules/terraform-aws-ecs"
#    ami                   = "ami-4cbe0935"
    ami_update            = "true"
    environment           = "${var.environment}"
    pet_name              = "${random_pet.this.id}"
    security_group        = "${module.security_group.id}"
    instance_type         = "t2.micro"
    key_name              = "${module.key-pair.key_name}"
    count_public_a        = "1"
    subnet_public_zone_a  = "${module.vpc.values["public_subnet_a"]}"
    count_public_b        = "1"
    subnet_public_zone_b  = "${module.vpc.values["public_subnet_b"]}"
    count_public_c        = "0"
    subnet_public_zone_c  = "${module.vpc.values["public_subnet_c"]}"
    tags = "${merge(var.tags, map("Name", "${var.environment}-${random_pet.this.id}", "Environment", "${var.environment}"))}"
}
