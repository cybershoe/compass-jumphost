terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.56"
    }
    namecheap = {
      source = "namecheap/namecheap"
      version = ">= 2.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_security_group" "allow_ssh_rdp" {
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_source]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.prefix}-allow-ssh-rdp"
  })
}

resource "random_string" "password" {
  count            = var.replicas
  length           = 10
  special          = true
  min_lower        = 1
  min_upper        = 1
  min_special      = 1
  min_numeric      = 1
  override_special = "$#+@%^"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = [var.ami_pattern]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu_instance" {
  count                       = var.replicas
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.allow_ssh_rdp.id]
  key_name                    = var.keypair_name
  associate_public_ip_address = true
  root_block_device {
    volume_size = 16
  }

  user_data = templatefile("${path.module}/files/setup.sh.tftpl", {
    password          = random_string.password[count.index].result,
    hostname          = "${var.prefix}${format("-%03d", count.index+1)}",
    domain            = var.dns_domain,
    lab_guide_url     = var.lab_guide_url,
    branding_jar_url  = var.branding_jar_url
    username          = "${format("user%03d", count.index + 1)}",
    certbot_staging   = var.certbot_staging ? "--test-cert " : "",
    atlas_hostname    = substr(var.connection_strings[count.index], 14, -1),
    urlencoded_pw     = urlencode(random_string.password[count.index].result)
  })
  user_data_replace_on_change = true

  tags = merge(var.tags, {
    Name = "${var.prefix}-${format("jumphost-%03d", count.index + 1)}"
  })
}

resource "namecheap_domain_records" "instance_dns_name" {
  count  = var.replicas
  domain = var.dns_domain

  record { 
    hostname = "${var.prefix}${format("-%03d", count.index+1)}"
    type     = "A"
    address  = aws_instance.ubuntu_instance[count.index].public_ip
    ttl      = 180
  }
}

output "instance_password_map" {
  value = [
    for i in range(var.replicas) : {
      ip       = aws_instance.ubuntu_instance[i].public_ip
      url      = "https://${var.prefix}${format("-%03d", i + 1)}.${var.dns_domain}/"
      username = "${format("user%03d", i + 1)}"
      password = random_string.password[i].result
    }
  ]
}
