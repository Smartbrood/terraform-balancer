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
            "name": "PRODUCTION",
            "value": "${ PRODUCTION }"
         },
         {
            "name": "CANARY",
            "value": "${ CANARY }"
         }],
        "mountPoints": [],
        "volumesFrom": [],
        "extraHosts": null,
        "logConfiguration": null,
        "ulimits": null,
        "dockerLabels": null
    }
]

