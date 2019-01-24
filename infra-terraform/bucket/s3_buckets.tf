variable "profile" {
  default = "test-dev"
}
variable "region" {
  default = "eu-west-1"
}

#------------------------------------------#
# AWS Provider Configuration
#------------------------------------------#
provider "aws" {
  region = "${var.region}"
  profile = "${var.profile}"
}

#------------------------------------------#
# Encrytion key
#------------------------------------------#
resource "aws_kms_key" "k8s-terraform-key" {
  description             = "This key is used to encrypt terraform remote state for k8s - Nico Dev"
  deletion_window_in_days = 10
}

#------------------------------------------#
# S3 Bucket
#------------------------------------------#
resource "aws_s3_bucket" "terraform_remote" {
  bucket = "k8s-tf-state-nico-dev"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.k8s-terraform-key.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }
}
