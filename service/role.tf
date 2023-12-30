# Batch Service Role
resource "aws_iam_role" "aws_batch_service_role" {
  name = "my-project-batch-service-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [{
    "Action": "sts:AssumeRole",
    "Effect": "Allow",
    "Principal": {
      "Service": "batch.amazonaws.com"
    }
  }]
}
EOF
  # Adding an inline policy to allow iam:PassRole
  inline_policy {
    name = "PassRolePolicy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [{
        Action   = "iam:PassRole",
        Effect   = "Allow",
        Resource = "arn:aws:iam::244883884162:role/AWSBatchServiceRole"
      }]
    })
  }

  # Adding a new inline policy for ECR permissions
  inline_policy {
    name = "ECRPermissionsPolicy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [{
        Action   = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
        ],
        Effect   = "Allow",
        Resource = "*",
      }]
    })
  }
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

# ECS Task Execution Role
resource "aws_iam_role" "aws_ecs_task_execution_role" {
  name = "my-project-ecs-task-execution-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  # Adding additional inline policies for ECS, Logs, and Auto Scaling
  inline_policy {
    name = "ECSPolicy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action   = "ecs:*",
          Effect   = "Allow",
          Resource = "*",
        },
      ]
    })
  }

  inline_policy {
    name = "LogsPolicy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action   = "logs:*",
          Effect   = "Allow",
          Resource = "*",
        },
      ]
    })
  }

  inline_policy {
    name = "AutoScalingPolicy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          "Effect"   = "Allow",
          "Action"   = "autoscaling:*",
          "Resource" = "*",
        },
      ]
    })
  }

  inline_policy {
    name = "ECRPermissionsPolicy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Action   = [
            "ecr:GetAuthorizationToken",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
          ],
          Effect   = "Allow",
          Resource = "*",
        },
      ]
    })
  }
}


resource "aws_iam_role_policy_attachment" "aws_ecs_task_execution_role" {
  role       = aws_iam_role.aws_ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}