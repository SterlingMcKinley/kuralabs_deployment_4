#configure aws provider
provider "aws" {
  region    = var.region
  profile   = "default"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

#create vpc
module "myvpc" {
  source                            = "../module_deployment4/vpc_module"
  region                            = var.region
  project_name                      = var.project_name
  vpc_cidr                          = var.vpc_cidr
  public_subnet_az1_cidr            = var.public_subnet_az1_cidr
  public_subnet_az2_cidr            = var.public_subnet_az2_cidr
 }
