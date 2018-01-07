terraform-balancer
==================

Terraform code for proof-of-concept for Canary releases in AWS with Nginx and ALB AWS.


Usage
-----

```
aws configure     - setup access key for AWS.

make apply        - deploy to AWS.

curl --header "X-Canary: canary" http://{alb_dns_name} - check load balancer. alb_dns_name - will be in "make apply" or "terraform apply" output.

terraform destroy - delete resources from AWS.


Use commands below instead of "make apply" if you don't have "make":

terraform init
terraform apply -var 'public_key_path=[path_to_public_ssh_key]'
```


Description
-----------

This code will create: VPC, subnetworks, routing tables, ECS cluster, EC2 instances fro ECS cluster, security_group, aws_key_pair, iam_role and three ECS services: balancer, production, canary. All ECS services with AWS application load balancers.

Code for docker images used in ECS services in "./docker". 
