terraform {
  required_version = ">= 1.0.2"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "team_3_terraform" {
 bucket = "team-3-terraform-state"
 acl    = "private"

 versioning {
   enabled = true
 }

}

resource "aws_s3_bucket_public_access_block" "block" {
 bucket = aws_s3_bucket.team_3_terraform.id

 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}

resource "aws_dynamodb_table" "team_3_terraform_db" {
 name           = "team_3_terraform_db"
 read_capacity  = 20
 write_capacity = 20
 hash_key       = "LockID"

 attribute {
   name = "LockID"
   type = "S"
 }
}
