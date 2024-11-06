# store the terraform state file in s3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket         = "dillon1-terraform-remote-state"
    key            = "shopwise-ec2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock"
    profile        = "cloud-projet-user"
  }
}
