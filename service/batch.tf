resource "aws_batch_compute_environment" "batch" {
  compute_environment_name = "my-project-compute-env"

  compute_resources {
    max_vcpus = 6
    security_group_ids = [
      aws_security_group.batch.id,
    ]
    subnets = data.aws_subnet_ids.all_default_subnets.ids
    type    = "FARGATE"
  }
  service_role = aws_iam_role.aws_batch_service_role.arn
  type         = "MANAGED"
  depends_on = [
    aws_iam_role_policy_attachment.aws_batch_service_role
  ]
}

resource "aws_batch_job_queue" "batch" {
  name     = "my-project-job-queue-example"
  state    = "ENABLED"
  priority = "0"
  compute_environments = [
    aws_batch_compute_environment.batch.arn,
  ]
}

resource "aws_batch_job_definition" "batch" {
  name = "my-project-job-definition"
  type = "container"
  platform_capabilities = [
    "FARGATE",
  ]
  container_properties = jsonencode({

    command = [
      "mpirun",
      "-np",
      "6",
      "/opt/qe-6.8/bin/pw.x",
      "-in",
      "/workdir/input.in",
    ]
    image = var.ecr_image_uri

    fargatePlatformConfiguration = {
      platformVersion = "LATEST"
    }

    networkConfiguration = {
      assignPublicIp = "ENABLED"
    }

    resourceRequirements = [
      {
        type  = "VCPU"
        value = "0.25"
      },
      {
        type  = "MEMORY"
        value = "512"
      }
    ]
    environment = [
      { name = "AWS_ACCESS_KEY_ID", value = jsondecode(data.aws_secretsmanager_secret_version.your_secret.secret_string)["AWS_ACCESS_KEY_ID"] },
      { name = "AWS_SECRET_ACCESS_KEY", value = jsondecode(data.aws_secretsmanager_secret_version.your_secret.secret_string)["AWS_SECRET_ACCESS_KEY"] },
      { name = "AWS_DEFAULT_REGION", value = jsondecode(data.aws_secretsmanager_secret_version.your_secret.secret_string)["AWS_DEFAULT_REGION"] },
    ]

    executionRoleArn = aws_iam_role.aws_ecs_task_execution_role.arn
  })
}
