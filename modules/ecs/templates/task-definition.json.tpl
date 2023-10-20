[
    {
      "name": "${name}",
      "image": "${container_image}",
      "cpu": ${cpu},
      "memory": ${memory},
      "memoryReservation": ${memory},
      "environment": [
        {
           "name": "jenkins_controller_arn",
           "value": "${jenkins_controller_arn}"
        },
        {
           "name": "agent_security_groups",
           "value": "${jenkins_controller_security_group_id}"
        },
        {
           "name": "region",
           "value": "${region}"
        },
      ],
      "essential": true,
      "portMappings": [
        {
          "containerPort": ${jenkins_controller_port}
        },
        {
          "containerPort": ${jnlp_port}
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${log_group}",
            "awslogs-region": "${region}",
            "awslogs-stream-prefix": "controller"
        }
      }
    }
]
