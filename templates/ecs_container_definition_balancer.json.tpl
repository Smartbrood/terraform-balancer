[
    {
        "name": "balancer",
        "image": "smartbrood/balancer:nginx",
        "cpu": 10,
        "memory": 200,
        "essential": true,
        "portMappings": [
             {
                 "hostPort": 0,
                 "containerPort": 80,
                 "protocol": "tcp"
             },
             {
                 "hostPort": 0,
                 "containerPort": 443,
                 "protocol": "tcp"
             }
         ],
        "links": [],
        "environment": [{
            "name": "PRIVATE_ALB",
            "value": "${ PRIVATE_ALB }"
         }],
        "mountPoints": [],
        "volumesFrom": [],
        "extraHosts": null,
        "logConfiguration": null,
        "ulimits": null,
        "dockerLabels": null
    }
]

