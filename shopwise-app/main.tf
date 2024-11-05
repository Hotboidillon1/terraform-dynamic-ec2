locals {
  region            = "us-east-1"
  project_name      = "shopwise"
  environment       = "dev"
  project_directory = "shopwise-app"
  domain_name       = "mycooldomain225.com"
  record_name       = "www"
}

module "shopwise-app" {
  source = "../infrastructure"

  # environment variables
  region            = local.region
  project_name      = local.project_name
  environment       = local.environment
  project_directory = local.project_directory

  # vpc variables
  vpc_cidr                     = "10.0.0.0/16"
  public_subnet_az1_cidr       = "10.0.0.0/24"
  public_subnet_az2_cidr       = "10.0.1.0/24"
  private_app_subnet_az1_cidr  = "10.0.2.0/24"
  private_app_subnet_az2_cidr  = "10.0.3.0/24"
  private_data_subnet_az1_cidr = "10.0.4.0/24"
  private_data_subnet_az2_cidr = "10.0.5.0/24"

  # secrets manager variables
  secrets_manager_secret_name = "shopwise-app"

  # rds variables
  multi_az_deployment          = "false"
  database_instance_identifier = "app-db"
  database_instance_class      = "db.t3.micro"
  publicly_accessible          = "false"

  # acm variables
  domain_name       = local.domain_name
  alternative_names = "*.mycooldomain225.com"

  # sns topic variables
  operator_email = "hotboidillon@yahoo.com"

  # auto scaling group variables
  amazon_linux_ami_id = "ami-06b21ccaeff8cd686"
  ec2_instance_type   = "t2.micro"

  # route-53 variables
  record_name = local.record_name
}