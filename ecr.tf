resource "aws_ecr_repository" "python_app_repo" {
  name                 = "python_app_repo"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  force_delete = true
}

resource "aws_ecr_lifecycle_policy" "python_app_policy" {
  repository = aws_ecr_repository.python_app_repo.name

  policy = jsonencode({
    "rules" : [
      {
        "rulePriority" : 1,
        "description" : "Keep last 30 images",
        "selection" : {
          "tagStatus" : "any",
          "countType" : "imageCountMoreThan",
          "countNumber" : 30
        },
        "action" : {
          "type" : "expire"
        }
      }
    ]
  })
}