data "aws_ecr_authorization_token" "token" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  ecr_endpoint = split("/", aws_ecr_repository.repo.repository_url)[0]
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

resource "aws_ecr_repository" "repo" {
  name                 =  var.repo_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration  {
    scan_on_push = true
  }
}

resource "null_resource" "build_docker_image" {
  provisioner "local-exec" {
    command = <<EOF
aws ecr get-login-password --region ${local.region} | docker login --username AWS --password-stdin ${local.account_id}.dkr.ecr.${local.region}.amazonaws.com
EOF
  }
}
