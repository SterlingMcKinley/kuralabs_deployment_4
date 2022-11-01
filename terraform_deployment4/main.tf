#configure aws provider
provider "aws" {
  region    = var.region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

#create vpc
module "myvpc" {
  source                            = "./module_deployment4/vpc_module"
  region                            = var.region
  project_name                      = var.project_name
  vpc_cidr                          = var.vpc_cidr
  public_subnet_az1_cidr            = var.public_subnet_az1_cidr
  public_subnet_az2_cidr            = var.public_subnet_az2_cidr

}

#creates aws instances #1 and attaches script to instance via user data
resource "aws_instance" "web_server01" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  key_name = "awskey"
  vpc_security_group_ids = module.myvpc.security_group
  subnet_id = module.myvpc.public_subnet_az1_id

  user_data = "${file("deploy.sh")}"

  tags = {
    "Name" : "Deployment4"
  }
}

#creates aws instances #2 and attaches script to instance via user data
resource "aws_instance" "web_server02" {
  ami = "ami-08c40ec9ead489470"
  instance_type = "t2.micro"
  key_name = "awskey"
  vpc_security_group_ids = module.myvpc.security_group
  subnet_id = module.myvpc.public_subnet_az2_id
  
  # vpc_security_group_ids = [aws_security_group.web_ssh.id]

  user_data = "${file("deploy.sh")}"

  tags = {
    "Name" : "Deployment4"
  }
}
output "instance_ip1" {
  value = aws_instance.web_server01.public_ip
  
}

output "instance_ip2" {
  value = aws_instance.web_server02.public_ip
  
}