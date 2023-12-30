resource "aws_ecr_repository" "ecr_repo" {
  name = "quantum_espresso"
  image_scanning_configuration {
    scan_on_push = true
  }
}
