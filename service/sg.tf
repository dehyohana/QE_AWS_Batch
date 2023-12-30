resource "aws_security_group" "batch" {

  name   = "batch"
  vpc_id = data.aws_vpc.default.id
  description = "batch VPC security group"
  
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }
}