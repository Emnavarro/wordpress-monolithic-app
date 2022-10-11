data "aws_availability_zones" "available" {
  state = "available"
}

#Create VPC Terraform modules

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.16.0"
  #version = "~> 3.0"

  name = var.vpc_name
  cidr = var.vpc_cidr_block

  azs            = var.vpc_availability_zones
  public_subnets = var.vpc_public_subnets

  public_subnet_tags = {
    Name = "Public subnet"
  }
}

output "vpc" {
  value = module.vpc.public_subnets
}