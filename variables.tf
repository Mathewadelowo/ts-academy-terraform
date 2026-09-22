variable "aws_region" {
  description = "AWS region where the infrastructure will be deployed"
  type        = string
}

variable "project_name" {
  description = "Name used to identify the project resources"
  type        = string
}


# Vpc Block
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "db_password" {
  description = "Password for the RDS database"
  type        = string
  sensitive   = true
}

# variable "public_subnet_cidr" {
#   description = "CIDR block for the public subnet"
#   type        = string
# }

# variable "private_subnet_cidr" {
#   description = "CIDR block for the private subnet"
#   type        = string
# }

# variable "database_subnet_cidr" {
#   description = "CIDR block for the database subnet"
#   type        = string
# }

# variable "environment" {
#   description = "Deployment environment"
#   type        = string
# }
