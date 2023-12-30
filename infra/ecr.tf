resource "aws_ecr_repository" "ecr_repo" {
  name = "quantum_espresso" #change to your desired repository name
  image_scanning_configuration {
    scan_on_push = true
  }
}
