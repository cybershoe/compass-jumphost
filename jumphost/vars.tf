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

variable "ssh_source" {
  description = "Source IP for SSH access"
  type        = string
}

variable "dns_domain" {
  description = "Domain for DNS records"
  type        = string
}

variable "lab_guide_url" {
  description = "URL to lab guide to place on desktop"
  type        = string
}

variable "branding_jar_url" {
  description = "URL for guacamole branding.jar"
  type        = string
}

variable "instance_type" {
  description = "Instance type for jumphosts"
  type        = string
}

variable "ami_pattern" {
  description = "AMI search pattern for jumphosts"
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