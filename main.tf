terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.56"
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

module "cloud" {
  source             = "./cloud"
  tags               = local.tags
  prefix             = var.prefix
  region             = var.region
  availability_zone  = var.availability_zone
  public_key_openssh = tls_private_key.ssh_key.public_key_openssh
}

module "jumphost" {
  source        = "./jumphost"
  tags          = local.tags
  prefix        = var.prefix
  region        = var.region
  replicas      = var.replicas
  vpc_id        = module.cloud.vpc_id
  subnet_id     = module.cloud.public_subnet_id
  keypair_name  = module.cloud.keypair_name
  instance_type = var.jumphost_instance_type
  ddns_domain   = var.ddns_domain
  ddns_password = var.ddns_password
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096

}

resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "./.ssh/terraform_rsa"
}

resource "local_file" "public_key" {
  content  = tls_private_key.ssh_key.public_key_openssh
  filename = "./.ssh/terraform_rsa.pub"
}


output "credentials" {
  value = module.jumphost.instance_password_map
}