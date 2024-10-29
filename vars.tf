variable "owner" {
  description = "Value of the owner tag on all created cloud resources"
  type        = string
}

variable "purpose" {
  description = "Value of the purpose tag on all created cloud resources"
  type        = string
  validation {
    condition     = contains(["training", "partner", "opportunity", "other"], var.purpose)
    error_message = "purpose tag must be one of [training|partner|opportunity|other]"
  }
  default = "training"
}

variable "expires" {
  description = "Value of the expires tag on all created cloud resources"
  type        = string
}

variable "prefix" {
  description = "Prefix for object names"
  type        = string
  default     = "default"
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

variable "region" {
  description = "Region in which to deploy jumphosts"
  type        = string
  default     = "us-east-1"
}

variable "ami_id" {
  description = "AMI id for jumphosts"
  type        = string
  default     = "ami-0cad6ee50670e3d0e"
}

variable "instance_type" {
  description = "Instance type for jumphosts"
  type        = string
}

variable "replicas" {
  description = "Number of jumphosts to deploy"
  type        = number
  default     = 1
}

variable "availability_zone" {
  description = "Availaility zone for public subnet"
  type        = string
  default     = "us-east-1a"
}

variable "certbot_staging" {
  description = "Set to true to use the staging Let's Encrypt environment"
  type        = bool
  default     = false
}