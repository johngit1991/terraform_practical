terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "dev-tf-test-bucket"
    key    = "dev/dev.tfstate" 
    region = "eu-west-2"
  }
}

/* note: backend type does not take any variable and bucket should be created already */

module "vpc-module" {
  source            = "./modules/vpc"
  vpc_cidr_block    = var.vpc_cidr_block
  availability_zone = var.availability_zone
  subnet_cidr_block = var.subnet_cidr_block
  env_prefix        = var.env_prefix
  myip              = var.myip
}


module "ec2-module" {
  source               = "./modules/ec2"
  instance_type        = var.instance_type
  availability_zone    = var.availability_zone
  subnet_id1           = module.vpc-module.subnet_id2
  sg                   = [module.vpc-module.sg_id]
  key_name             = aws_key_pair.mykey.key_name
  private_key_path     = var.private_key_path
  userdata_entryscript = var.userdata_entryscript
  remote_exec_script   = var.remote_exec_script
}


resource "aws_key_pair" "mykey" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}