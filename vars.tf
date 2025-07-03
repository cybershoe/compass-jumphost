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

variable "lab_guide_url" {
  description = "URL to lab guide to place on desktop"
  type        = string
  default     = "https://raw.githubusercontent.com/cybershoe/compass-jumphost/478027418e7f5bb2be3d41a26aba82b601f474ab/lab-guide.pdf"
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
  description = "Availaility zone for public subnet"
  type        = string
  default     = "us-east-1a"
}

variable "ssh_source" {
  description = "Source IP for SSH access"
  type        = string
}

variable "certbot_staging" {
  description = "Set to true to use the staging Let's Encrypt environment"
  type        = bool
  default     = false
}