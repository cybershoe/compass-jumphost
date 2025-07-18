terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.56"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.1"
    }
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "~> 1.38"
    }
  }
}

locals {
  tags = {
    owner   = var.owner
    purpose = var.purpose
    expires = var.expires
  }

}

data "http" "my_ip" {
  count = var.ssh_source == null ? 1 : 0
  url = "https://ifconfig.me/ip" 
}

module "cloud" {
  source             = "./cloud"
  tags               = local.tags
  prefix             = var.prefix
  region             = var.region
  availability_zone  = var.availability_zone
  public_key_openssh = tls_private_key.ssh_key.public_key_openssh
}

module "jumphost" {
  source           = "./jumphost"
  tags             = local.tags
  prefix           = var.prefix
  region           = var.region
  ssh_source       = var.ssh_source == null ? "${data.http.my_ip[0].response_body}/32" : var.ssh_source
  replicas         = var.replicas
  vpc_id           = module.cloud.vpc_id
  subnet_id        = module.cloud.public_subnet_id
  keypair_name     = module.cloud.keypair_name
  instance_type    = var.instance_type
  ami_pattern      = var.ami_pattern
  dns_domain       = var.dns_domain
  lab_guide_url    = var.lab_guide_url
  branding_jar_url = var.branding_jar_url
  certbot_staging  = var.certbot_staging
  connection_strings = module.atlas.connection_strings
}

module "atlas" {
  source       = "./atlas"
  # public_key   = var.mongodb_atlas_public_api_key
  # private_key  = var.mongodb_atlas_private_api_key
  project_id   = var.atlas_project_id
  prefix       = var.prefix
  owner        = var.owner
  replicas     = var.replicas
  jumphosts    = module.jumphost.instance_password_map
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "./.ssh/terraform_rsa"
  file_permission = "0600"
  
}

resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "./.ssh/terraform_rsa.pub"
}

output "credentials" {
  value = module.jumphost.instance_password_map
}