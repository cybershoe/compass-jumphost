variable "tags" {
  description = "Tags to be applied to all created cloud resources"
}

variable "prefix" {
  description = "Prefix for all created cloud resources"
}

variable "replicas" {
  type = number
}

variable "region" {
  type = string
}

variable "ddns_domain" {
  description = "Domain for dynamic DNS updates"
  type        = string
}

variable "ddns_password" {
  description = "Password for dynamic DNS updates"
  type        = string
  sensitive   = true
}

variable "instance_type" {
  description = "Instance type for jumphosts"
  type        = string
}

variable "ami_id" {
  description = "AMI id for jumphosts"
  type        = string
}

variable "vpc_id" {
  description = "vpc id for jumphosts"

}

variable "subnet_id" {
  description = "subnet id for jumphosts"
}

variable "keypair_name" {
  description = "ssh key pair for jumphosts"
}

variable "certbot_staging" {
  description = "Set to true to use the staging Let's Encrypt environment"
  type        = bool
}