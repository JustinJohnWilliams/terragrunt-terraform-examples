terraform {
  source = "../../../../../modules/fargate_service"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "${get_parent_terragrunt_dir("root")}/us-east-2/shared_infra/vpc"
}

inputs = {
  name              = "my-awesome-fargate-service"
  vpc_id            = dependency.vpc.outputs.vpc_id
  container_port    = 8001
  public_subnets    = values(dependency.vpc.outputs.public_subnets)[*].id
  private_subnets   = values(dependency.vpc.outputs.private_subnets)[*].id
  health_check_path = "/"
  iam_policies = {
    "AllowFargateS3Access" = {
      Actions   = ["s3:ListBucket", "s3:PutObject", "s3:GetObject", "s3:DeleteObject"],
      Effect    = "Allow",
      Resources = ["*"]
    }
  }
}