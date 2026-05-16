terraform {
  backend "s3" {
    bucket         = "three-tier-app-tfstate-379820351868" # <-- Apni unique bucket string dalo
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"                          # <-- Updated to Mumbai
    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}