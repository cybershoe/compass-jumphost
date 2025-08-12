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

variable "dns_domain" {
  description = "Domain for DNS records"
  type        = string
}

variable "lab_repo" {
  description = "URL of the lab repository to clone"
  type        = string
  default     = "https://github.com/cybershoe/lab-example.git"
}

variable "lab_guide_url" {
  description = "URL to lab guide to place on desktop"
  type        = string
  default     = "http://localhost:3000/"
}

variable "branding_jar_url" {
  description = "URL for guacamole branding.jar"
  type        = string
  default     = "https://github.com/cybershoe/compass-jumphost/raw/refs/heads/main/branding/branding.jar"
}

variable "region" {
  description = "Region in which to deploy jumphosts"
  type        = string
  default     = "us-east-1"
}

variable "ami_pattern" {
  description = "AMI search pattern for jumphosts"
  type        = string
  default     = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"
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
  description = "Availability zone for public subnet"
  type        = string
  default     = null
}

variable "ssh_source" {
  description = "Source IP for SSH access"
  type        = string
  default     = null
}

variable "certbot_staging" {
  description = "Set to true to use the staging Let's Encrypt environment"
  type        = bool
  default     = false
}

# variable mongodb_atlas_public_api_key {
#   type        = string
#   description = "MongoDB Atlas Public Key"
# }

# variable mongodb_atlas_private_api_key {
#   type        = string
#   description = "MongoDB Atlas Private Key"
#   sensitive   = true
# }

# variable atlas_project_id {
#   type        = string
#   description = "MongoDB Atlas Project ID"
# }

variable atlas_org_id {
  type        = string
  description = "MongoDB Atlas Organization ID"
}

variable simple_passwords {
  description = "Use simple passwords for jumphosts"
  type        = string
  default     = false
}