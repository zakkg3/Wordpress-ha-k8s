#------------------------------------------#
# AWS Environment Variables
#------------------------------------------#
variable "region" {
  description = "The region of AWS"
}

variable "profile" {
  description = "The default profile to use from .aws/credentials file"
}

variable "env" {}

variable "vpc_cidr" {
  default = "10.10.0.0/16"
}

variable "subnet_cidrs" {
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24", "10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24", "10.10.7.0/24", "10.10.8.0/24"] #for vpc_cdir 10.10.0.0/16
  description = "Subnet ranges (maximum zones available required)"
}

variable "node_type" {
  default = "t3.medium"
}
variable "desired_nodes" {
  default = 1
}
variable "admin_ip" {}

#------------------------------------------#
# retrieve remote data
#------------------------------------------#
#
# variable "backend_bucket" {
# }
#
# variable "backend_region" {
# }
#
# variable "backend_profile" {
# }
