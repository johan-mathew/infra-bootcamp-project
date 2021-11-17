terraform {
 backend "s3" {
   bucket         = "team-3-terraform-state"
   key            = "state/terraform.tfstate"
   region         = "ap-south-1"
   dynamodb_table = "team_3_terraform_db"
 }
}
