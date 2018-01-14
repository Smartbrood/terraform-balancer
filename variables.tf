variable "region" {
  description = "AWS Region"
  default = "eu-west-1"
}

variable "public_key_path" {
  description = "Path to ssh rsa public key"
  default = "~/.ssh/id_rsa.pub"
}

variable "environment" {
  description = "Name for environment."
  default = "stage"
}

variable "tags" {
  default = {
    Repository  = "terraform-balancer"
    Terraform   = "true"
  }
}

variable "balancer_count" {
  description = "Balancer tasks count."
  default = "2"
}

variable "production_count" {
  description = "Production tasks count."
  default = "2"
}

variable "canary_count" {
  description = "Canary tasks count."
  default = "2"
}
