# Retrieves the default vpc for this region
data "aws_vpc" "default" {
  default = true
}

# Retrieves the subnet ids in the default vpc
data "aws_subnet_ids" "all_default_subnets" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_secretsmanager_secret_version" "your_secret" {
  secret_id = "terraform_user"
}
