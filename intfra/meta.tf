data "aws_vpcs" "my_vpc" {
  # Assuming you have a specific tag to identify your VPC, modify this accordingly
  tags = {
    Name = "default"
  }
}
